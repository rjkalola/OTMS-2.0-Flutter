package com.app.belcka

import android.content.ContentValues
import android.content.Intent
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

class MainActivity : FlutterActivity() {

    private val liveTimerChannel = "live_timer"
    private val downloadsChannel = "com.app.belcka/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            liveTimerChannel
        ).setMethodCallHandler { call, result ->
            val intent = Intent(this, LiveTimerService::class.java)

            when (call.method) {
                "start" -> {
                    val seconds = call.argument<Int>("elapsedSeconds") ?: 0
                    intent.action = LiveTimerService.ACTION_START
                    intent.putExtra("elapsedSeconds", seconds.toLong())
                    ContextCompat.startForegroundService(this, intent)
                    result.success(null)
                }

                "pause" -> {
                    intent.action = LiveTimerService.ACTION_PAUSE
                    ContextCompat.startForegroundService(this, intent)
                    result.success(null)
                }

                "stop" -> {
                    intent.action = LiveTimerService.ACTION_STOP
                    ContextCompat.startForegroundService(this, intent)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            downloadsChannel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveToDownloads" -> {
                    val sourcePath = call.argument<String>("sourcePath")
                    val fileName = call.argument<String>("fileName")
                    if (sourcePath.isNullOrBlank() || fileName.isNullOrBlank()) {
                        result.error(
                            "INVALID_ARGS",
                            "sourcePath and fileName are required",
                            null
                        )
                        return@setMethodCallHandler
                    }
                    try {
                        val savedPath = saveToPublicDownloads(sourcePath, fileName)
                        result.success(savedPath)
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun saveToPublicDownloads(sourcePath: String, fileName: String): String {
        val sourceFile = File(sourcePath)
        if (!sourceFile.exists()) {
            throw IllegalArgumentException("Source file does not exist: $sourcePath")
        }

        val mimeType = guessMimeType(fileName)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val pending = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, mimeType)
                put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }

            val resolver = contentResolver
            val collection = MediaStore.Downloads.EXTERNAL_CONTENT_URI
            val itemUri =
                resolver.insert(collection, pending)
                    ?: throw IllegalStateException("MediaStore insert failed")

            resolver.openOutputStream(itemUri)?.use { out ->
                FileInputStream(sourceFile).use { input ->
                    input.copyTo(out)
                }
            } ?: throw IllegalStateException("Could not open MediaStore output stream")

            val completed = ContentValues().apply {
                put(MediaStore.Downloads.IS_PENDING, 0)
            }
            resolver.update(itemUri, completed, null, null)

            val path = resolveDownloadPath(itemUri, fileName)
            MediaScannerConnection.scanFile(this, arrayOf(path), arrayOf(mimeType), null)
            return cacheOpenableCopy(itemUri, fileName)
        }

        @Suppress("DEPRECATION")
        val downloadsDir =
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        if (!downloadsDir.exists()) {
            downloadsDir.mkdirs()
        }
        val destFile = File(downloadsDir, fileName)
        sourceFile.copyTo(destFile, overwrite = true)
        MediaScannerConnection.scanFile(
            this,
            arrayOf(destFile.absolutePath),
            arrayOf(mimeType),
            null
        )
        return cacheOpenableCopy(destFile, fileName)
    }

    private fun cacheOpenableCopy(source: File, fileName: String): String {
        val cacheFile = File(cacheDir, "download_open_$fileName")
        source.copyTo(cacheFile, overwrite = true)
        return cacheFile.absolutePath
    }

    private fun cacheOpenableCopy(sourceUri: Uri, fileName: String): String {
        val cacheFile = File(cacheDir, "download_open_$fileName")
        contentResolver.openInputStream(sourceUri)?.use { input ->
            cacheFile.outputStream().use { output ->
                input.copyTo(output)
            }
        } ?: throw IllegalStateException("Could not read saved download for opening")
        return cacheFile.absolutePath
    }

    private fun resolveDownloadPath(uri: Uri, fileName: String): String {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            return "/storage/emulated/0/Download/$fileName"
        }
        try {
            val projection = arrayOf(MediaStore.Downloads.DATA)
            contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val column = cursor.getColumnIndex(MediaStore.Downloads.DATA)
                    if (column >= 0) {
                        val data = cursor.getString(column)
                        if (!data.isNullOrBlank()) {
                            return data
                        }
                    }
                }
            }
        } catch (_: Exception) {
            // DATA column is not always available on scoped storage devices.
        }
        return "/storage/emulated/0/Download/$fileName"
    }

    private fun guessMimeType(fileName: String): String {
        return when {
            fileName.endsWith(".zip", ignoreCase = true) -> "application/zip"
            fileName.endsWith(".pdf", ignoreCase = true) -> "application/pdf"
            fileName.endsWith(".xlsx", ignoreCase = true) ->
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            fileName.endsWith(".xls", ignoreCase = true) -> "application/vnd.ms-excel"
            fileName.endsWith(".csv", ignoreCase = true) -> "text/csv"
            else -> "application/octet-stream"
        }
    }
}
