package com.app.belcka

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class LiveTimerService2 : Service() {

    private val CHANNEL_ID = "LIVE_TIMER_CHANNEL"

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        val elapsedSeconds =
            intent?.getLongExtra("elapsedSeconds", 0L) ?: 0L

        // ✅ THIS is the ONLY way we set start time
        val whenTimeMillis =
            System.currentTimeMillis() - (elapsedSeconds * 1000)

        createChannel()

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Working Hours")
            .setContentText("Shift in progress")
            .setSmallIcon(R.drawable.ic_launcher_foreground) // ✅ safe default
            .setWhen(whenTimeMillis)          // ✅ KEY LINE
            .setUsesChronometer(true)         // ✅ LIVE COUNTER
            .setChronometerCountDown(false)
            .setOngoing(true)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()

        startForeground(1001, notification)
        return START_STICKY
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
