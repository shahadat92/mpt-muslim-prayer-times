
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

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->

            val manager = getSystemService(ALARM_SERVICE) as AlarmManager

            when (call.method) {
                "canExact" -> {
                    result.success(canScheduleExact(manager))
                }

                "openExactSettings" -> {
                    if (Build.VERSION.SDK_INT >= 31) {
                        try {
                            startActivity(
                                Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                                    data = android.net.Uri.parse("package:$packageName")
                                }
                            )
                        } catch (_: Exception) {
                            try {
                                startActivity(
                                    Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                                        data = android.net.Uri.parse("package:$packageName")
                                    }
                                )
                            } catch (e: Exception) {
                                result.error("SETTINGS", e.message, null)
                                return@setMethodCallHandler
                            }
                        }
                    }
                    result.success(null)
                }

                "cancelAll" -> {
                    for (id in 10000 until 10050) {
                        cancelAlarm(manager, id)
                    }
                    result.success(null)
                }

                "schedule" -> {
                    val id = call.argument<Int>("id") ?: -1
                    val at = call.argument<Long>("at") ?: 0L
                    val audio = call.argument<String>("audio") ?: "regular_full"

                    if (id !in 10000 until 10050 ||
                        at <= System.currentTimeMillis() ||
                        !validAudio(audio)
                    ) {
                        result.error("INVALID", "Invalid alarm", null)
                    } else {
                        try {
                            scheduleAlarm(manager, id, at, audio)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("ALARM", e.message, null)
                        }
                    }
                }

                "testAdhan" -> {
                    val audio = call.argument<String>("audio") ?: "regular_short"

                    if (!validAudio(audio)) {
                        result.error("INVALID", "Invalid Adhan audio", null)
                    } else {
                        try {
                            val exact = canScheduleExact(manager)
                            val at = System.currentTimeMillis() + 30000L

                            cancelAlarm(manager, 10099)
                            scheduleAlarm(manager, 10099, at, audio)

                            result.success(
                                mapOf(
                                    "scheduled" to true,
                                    "exact" to exact,
                                    "delaySeconds" to 30
                                )
                            )
                        } catch (e: Exception) {
                            result.error("TEST_ALARM", e.message, null)
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun validAudio(audio: String): Boolean {
        return audio in setOf(
            "fajr_full",
            "fajr_short",
            "regular_full",
            "regular_short"
        )
    }

    private fun canScheduleExact(manager: AlarmManager): Boolean {
        return Build.VERSION.SDK_INT < 31 ||
            manager.canScheduleExactAlarms()
    }

    private fun scheduleAlarm(
        manager: AlarmManager,
        id: Int,
        at: Long,
        audio: String
    ) {
        val pending = alarmIntent(
            id,
            audio,
            PendingIntent.FLAG_UPDATE_CURRENT
        ) ?: throw IllegalStateException("Cannot create alarm")

        if (Build.VERSION.SDK_INT >= 31 && !manager.canScheduleExactAlarms()) {
            manager.setAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                at,
                pending
            )
        } else if (Build.VERSION.SDK_INT >= 23) {
            manager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                at,
                pending
            )
        } else {
            manager.setExact(
                AlarmManager.RTC_WAKEUP,
                at,
                pending
            )
        }
    }

    private fun cancelAlarm(manager: AlarmManager, id: Int) {
        val pending = alarmIntent(
            id,
            "regular_full",
            PendingIntent.FLAG_NO_CREATE
        )
        if (pending != null) {
            manager.cancel(pending)
            pending.cancel()
        }
    }

    private fun alarmIntent(
        id: Int,
        audio: String,
        flags: Int
    ): PendingIntent? {
        val intent = Intent(this, AdhanReceiver::class.java)
            .putExtra("audio", audio)

        return PendingIntent.getBroadcast(
            this,
            id,
            intent,
            flags or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
