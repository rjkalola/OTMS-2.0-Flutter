package com.app.belcka

import android.content.Intent
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "live_timer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "start" -> {
                    val seconds =
                        call.argument<Int>("elapsedSeconds") ?: 0

                    val intent =
                        Intent(this, LiveTimerService::class.java)
                    intent.putExtra("elapsedSeconds", seconds.toLong())

                    ContextCompat.startForegroundService(this, intent)
                    result.success(null)
                }

                "stop" -> {
                    stopService(Intent(this, LiveTimerService::class.java))
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}
