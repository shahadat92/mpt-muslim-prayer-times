package com.koreaprayertimes.korea_prayer_times

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder

class AdhanService : Service() {
    private var player: MediaPlayer? = null
    override fun onBind(intent: Intent?): IBinder? = null
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val audio = intent?.getStringExtra("audio") ?: "regular_full"
        val resId = resources.getIdentifier(audio, "raw", packageName)
        if (resId == 0) { stopSelf(); return START_NOT_STICKY }
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= 26) manager.createNotificationChannel(NotificationChannel("mpt_adhan_playback_v150", "Adhan playback", NotificationManager.IMPORTANCE_LOW))
        val builder = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(this, "mpt_adhan_playback_v150") else Notification.Builder(this)
        val notification = builder.setSmallIcon(applicationInfo.icon).setContentTitle("MPT · Adhan").setContentText("Prayer time adhan is playing").setOngoing(true).build()
        try {
            startForeground(15001, notification)
            player?.release()
            player = MediaPlayer.create(this, resId)?.apply {
                setOnCompletionListener { stopSelf() }
                setOnErrorListener { _, _, _ -> stopSelf(); true }
                start()
            }
            if (player == null) stopSelf()
        } catch (e: Exception) { android.util.Log.e("MPT_ADHAN", "Playback failed", e); stopSelf() }
        return START_NOT_STICKY
    }
    override fun onDestroy() {
        player?.run { try { if (isPlaying) stop() } catch (_: Exception) {}; release() }
        player = null
        super.onDestroy()
    }
}
