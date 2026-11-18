
package com.koreaprayertimes.korea_prayer_times

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import android.util.Log

class AdhanService : Service() {

    companion object {
        private const val CHANNEL_ID = "mpt_adhan_playback_v150"
        private const val NOTIFICATION_ID = 15001
        private const val ACTION_STOP = "com.koreaprayertimes.STOP_ADHAN"
    }

    private var player: MediaPlayer? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        // Stop Adhan immediately when the notification button is tapped.
        if (intent?.action == ACTION_STOP) {
            stopPlayback()
            stopSelf()
            return START_NOT_STICKY
        }

        val audio = intent?.getStringExtra("audio") ?: "regular_full"

        if (audio !in setOf(
                "fajr_full",
                "fajr_short",
                "regular_full",
                "regular_short"
            )
        ) {
            stopSelf()
            return START_NOT_STICKY
        }

        val resId = resources.getIdentifier(
            audio,
            "raw",
            packageName
        )

        if (resId == 0) {
            stopSelf()
            return START_NOT_STICKY
        }

        val manager = getSystemService(
            NOTIFICATION_SERVICE
        ) as NotificationManager

        if (Build.VERSION.SDK_INT >= 26) {
            manager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_ID,
                    "Adhan playback",
                    NotificationManager.IMPORTANCE_LOW
                )
            )
        }

        val stopIntent = Intent(this, AdhanService::class.java).apply {
            action = ACTION_STOP
        }

        val stopPendingIntent = PendingIntent.getService(
            this,
            15002,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or
                PendingIntent.FLAG_IMMUTABLE
        )

        val builder = if (Build.VERSION.SDK_INT >= 26) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            Notification.Builder(this)
        }

        val notification = builder
            .setSmallIcon(applicationInfo.icon)
            .setContentTitle("MPT · Adhan")
            .setContentText("Adhan is playing · আজান চলছে")
            .setOngoing(true)
            .addAction(
                android.R.drawable.ic_media_pause,
                "Stop Adhan · আজান বন্ধ",
                stopPendingIntent
            )
            .build()

        try {
            startForeground(NOTIFICATION_ID, notification)

            stopPlayback()

            player = MediaPlayer.create(this, resId)?.apply {
                setOnCompletionListener {
                    stopSelf()
                }

                setOnErrorListener { _, _, _ ->
                    stopSelf()
                    true
                }

                start()
            }

            if (player == null) {
                stopSelf()
            }

        } catch (e: Exception) {
            Log.e("MPT_ADHAN", "Playback failed", e)
            stopSelf()
        }

        return START_NOT_STICKY
    }

    private fun stopPlayback() {
        val current = player
        player = null

        if (current != null) {
            try {
                if (current.isPlaying) {
                    current.stop()
                }
            } catch (_: Exception) {
            }

            try {
                current.release()
            } catch (_: Exception) {
            }
        }
    }

    override fun onDestroy() {
        stopPlayback()
        super.onDestroy()
    }
}
