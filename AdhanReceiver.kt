package com.koreaprayertimes.korea_prayer_times

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class AdhanReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val audio = intent.getStringExtra("audio") ?: "regular_full"
        val service = Intent(context, AdhanService::class.java).putExtra("audio", audio)
        try {
            if (Build.VERSION.SDK_INT >= 26) context.startForegroundService(service)
            else context.startService(service)
        } catch (_: Exception) { /* Android may block background foreground-service starts. */ }
    }
}
