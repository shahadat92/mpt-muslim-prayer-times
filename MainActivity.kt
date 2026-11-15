package com.koreaprayertimes.korea_prayer_times

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "mpt/adhan_alarm"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            val manager = getSystemService(ALARM_SERVICE) as AlarmManager
            when (call.method) {
                "canExact" -> result.success(Build.VERSION.SDK_INT < 31 || manager.canScheduleExactAlarms())
                "openExactSettings" -> {
                    if (Build.VERSION.SDK_INT >= 31) {
                        try { startActivity(Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply { data = android.net.Uri.parse("package:$packageName") }) }
                        catch (_: Exception) { startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply { data = android.net.Uri.parse("package:$packageName") }) }
                    }
                    result.success(null)
                }
                "cancelAll" -> {
                    for (id in 10000 until 10050) {
                        val pending = alarmIntent(id, "regular_full", PendingIntent.FLAG_NO_CREATE)
                        if (pending != null) { manager.cancel(pending); pending.cancel() }
                    }
                    result.success(null)
                }
                "schedule" -> {
                    val id = call.argument<Int>("id") ?: -1
                    val at = call.argument<Long>("at") ?: 0L
                    val audio = call.argument<String>("audio") ?: "regular_full"
                    if (id !in 10000 until 10050 || at <= System.currentTimeMillis() || audio !in setOf("fajr_full","fajr_short","regular_full","regular_short")) {
                        result.error("INVALID", "Invalid alarm", null)
                    } else {
                        try {
                            val pending = alarmIntent(id, audio, PendingIntent.FLAG_UPDATE_CURRENT)!!
                            if (Build.VERSION.SDK_INT >= 31 && !manager.canScheduleExactAlarms()) {
                                manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, pending)
                            } else if (Build.VERSION.SDK_INT >= 23) {
                                manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, pending)
                            } else {
                                manager.setExact(AlarmManager.RTC_WAKEUP, at, pending)
                            }
                            result.success(true)
                        } catch (e: Exception) { result.error("ALARM", e.message, null) }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
    private fun alarmIntent(id: Int, audio: String, flags: Int): PendingIntent? {
        val intent = Intent(this, AdhanReceiver::class.java).putExtra("audio", audio)
        return PendingIntent.getBroadcast(this, id, intent, flags or PendingIntent.FLAG_IMMUTABLE)
    }
}
