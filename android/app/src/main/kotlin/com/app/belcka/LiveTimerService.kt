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

class LiveTimerService : Service() {

    private val CHANNEL_ID = "LIVE_TIMER_CHANNEL"

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        val elapsedSeconds =
            intent?.getLongExtra("elapsedSeconds", 0L) ?: 0L

        val baseElapsed =
            SystemClock.elapsedRealtime() - (elapsedSeconds * 1000L)

        createChannel()

        val views = RemoteViews(packageName, R.layout.notification_timer)
        views.setChronometer(R.id.chrono, baseElapsed, null, true)

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_launcher_foreground)

            // 🔒 PINNING REQUIREMENTS
            .setOngoing(true)
            .setAutoCancel(false)
            .setOnlyAlertOnce(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setForegroundServiceBehavior(
                NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE
            )

            // BIG TIMER
            .setCustomContentView(views)
            .setCustomBigContentView(views)

            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .build()

        // 🔑 MUST be called immediately
        startForeground(1001, notification)

        return START_STICKY
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
