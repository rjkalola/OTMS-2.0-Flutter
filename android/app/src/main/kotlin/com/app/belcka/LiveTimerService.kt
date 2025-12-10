package com.app.belcka

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.SystemClock
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat

//class LiveTimerService : Service() {
//
//    private val CHANNEL_ID = "LIVE_TIMER_CHANNEL"
//
//    override fun onStartCommand(
//        intent: Intent?,
//        flags: Int,
//        startId: Int
//    ): Int {
//
//        val elapsedSeconds =
//            intent?.getLongExtra("elapsedSeconds", 0L) ?: 0L
//
//        val baseElapsed =
//            SystemClock.elapsedRealtime() - (elapsedSeconds * 1000L)
//
//        createChannel()
//
//        val views = RemoteViews(packageName, R.layout.notification_timer)
//        views.setChronometer(R.id.chrono, baseElapsed, null, true)
//
//        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
//            .setSmallIcon(R.drawable.ic_launcher_foreground)
//
//            // 🔒 PINNING REQUIREMENTS
//            .setOngoing(true)
//            .setAutoCancel(false)
//            .setOnlyAlertOnce(true)
//            .setCategory(NotificationCompat.CATEGORY_SERVICE)
//            .setForegroundServiceBehavior(
//                NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE
//            )
//
//            // BIG TIMER
//            .setCustomContentView(views)
//            .setCustomBigContentView(views)
//
//            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
//            .build()
//
//        // 🔑 MUST be called immediately
//        startForeground(1001, notification)
//
//        return START_STICKY
//    }
//
//    override fun onDestroy() {
//        stopForeground(true)
//        super.onDestroy()
//    }
//
//    override fun onBind(intent: Intent?): IBinder? = null
//
//    private fun createChannel() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(
//                CHANNEL_ID,
//                "Live Work Timer",
//                NotificationManager.IMPORTANCE_LOW
//            )
//            getSystemService(NotificationManager::class.java)
//                .createNotificationChannel(channel)
//        }
//    }
//}


class LiveTimerService : Service() {

    companion object {
        const val ACTION_START = "ACTION_START"
        const val ACTION_PAUSE = "ACTION_PAUSE"
        const val ACTION_STOP = "ACTION_STOP"
    }

    private val CHANNEL_ID = "LIVE_TIMER_CHANNEL"

    // Timer state
    private var baseElapsed: Long = 0L
    private var pausedOffset: Long = 0L
    private var isPaused = false

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        when (intent?.action) {

            ACTION_START -> {
                // If paused → resume
                // If new start → elapsedSeconds used
                val elapsedSeconds =
                    intent.getLongExtra("elapsedSeconds", -1L)

                baseElapsed = if (isPaused) {
                    SystemClock.elapsedRealtime() - pausedOffset
                } else {
                    SystemClock.elapsedRealtime() -
                            (elapsedSeconds.coerceAtLeast(0) * 1000L)
                }

                isPaused = false
            }

            ACTION_PAUSE -> {
                if (!isPaused) {
                    pausedOffset =
                        SystemClock.elapsedRealtime() - baseElapsed
                    isPaused = true
                }
            }

            ACTION_STOP -> {
                stopSelf()
                return START_NOT_STICKY
            }
        }

        showNotification()
        return START_STICKY
    }

    private fun showNotification() {

        createChannel()

        val views = RemoteViews(packageName, R.layout.notification_timer)

        views.setChronometer(
            R.id.chrono,
            baseElapsed,
            null,
            !isPaused
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_launcher_foreground)
            .setOngoing(true)
            .setAutoCancel(false)
            .setOnlyAlertOnce(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setForegroundServiceBehavior(
                NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE
            )
            .setCustomContentView(views)
            .setCustomBigContentView(views)
            .build()
        startForeground(1001, notification)
    }

    override fun onDestroy() {
        stopForeground(true)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Live Work Timer",
                NotificationManager.IMPORTANCE_LOW
            )
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }
}
