package kz.bizlevel.bizlevel

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "bizlevel/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDefaultNotificationSoundUri" -> {
                    try {
                        // Получаем реальный URI системного звука уведомлений
                        val actualUri = RingtoneManager.getActualDefaultRingtoneUri(applicationContext, RingtoneManager.TYPE_NOTIFICATION)
                        result.success(actualUri?.toString() ?: "")
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to get notification sound URI", e.message)
                    }
                }
                "updateChannelSound" -> {
                    try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            val channelId = call.argument<String>("channelId")
                            val soundUri = call.argument<String>("soundUri")
                            if (channelId != null && soundUri != null) {
                                val notificationManager = getSystemService(NotificationManager::class.java)
                                // Удаляем старый канал
                                notificationManager.deleteNotificationChannel(channelId)
                                android.util.Log.i("MainActivity", "Deleted channel: $channelId")
                                // Создаем новый канал с реальным URI звука
                                val uri = Uri.parse(soundUri)
                                android.util.Log.i("MainActivity", "Creating channel with sound URI: $soundUri")
                                val audioAttributes = AudioAttributes.Builder()
                                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                                    .build()
                                val channel = NotificationChannel(
                                    channelId,
                                    "Напоминания по целям",
                                    NotificationManager.IMPORTANCE_HIGH
                                ).apply {
                                    description = "План недели, середина недели и чекин"
                                    setSound(uri, audioAttributes)
                                    enableVibration(true)
                                }
                                notificationManager.createNotificationChannel(channel)
                                // Проверяем, что канал создан с правильным звуком
                                val createdChannel = notificationManager.getNotificationChannel(channelId)
                                android.util.Log.i("MainActivity", "Channel created, sound: ${createdChannel?.sound}")
                                result.success(true)
                            } else {
                                result.error("ERROR", "Missing parameters", null)
                            }
                        } else {
                            result.success(false)
                        }
                    } catch (e: Exception) {
                        android.util.Log.e("MainActivity", "Failed to update channel sound", e)
                        result.error("ERROR", "Failed to update channel sound", e.message)
                    }
                }
                "showNotificationWithSound" -> {
                    try {
                        val channelId = call.argument<String>("channelId")
                        val title = call.argument<String>("title")
                        val body = call.argument<String>("body")
                        val soundUri = call.argument<String>("soundUri")
                        if (channelId != null && title != null && body != null && soundUri != null) {
                            val notificationManager = getSystemService(NotificationManager::class.java)
                            val channel = notificationManager.getNotificationChannel(channelId)
                            if (channel != null) {
                                val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    android.app.Notification.Builder(applicationContext, channelId)
                                } else {
                                    @Suppress("DEPRECATION")
                                    android.app.Notification.Builder(applicationContext)
                                }
                                val iconResId = resources.getIdentifier("ic_stat_ic_notification", "drawable", packageName)
                                builder.setContentTitle(title)
                                    .setContentText(body)
                                    .setSmallIcon(if (iconResId != 0) iconResId else android.R.drawable.ic_dialog_info)
                                    .setAutoCancel(true)
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    builder.setChannelId(channelId)
                                }
                                // Используем defaults для системного звука
                                // На Android 8+ setSound может игнорироваться, если канал имеет свой звук
                                builder.setDefaults(android.app.Notification.DEFAULT_SOUND or android.app.Notification.DEFAULT_VIBRATE)
                                val notification = builder.build()
                                notificationManager.notify(System.currentTimeMillis().toInt(), notification)
                                android.util.Log.i("MainActivity", "Notification shown with sound: $soundUri")
                                result.success(true)
                            } else {
                                result.error("ERROR", "Channel not found", null)
                            }
                        } else {
                            result.error("ERROR", "Missing parameters", null)
                        }
                    } catch (e: Exception) {
                        android.util.Log.e("MainActivity", "Failed to show notification", e)
                        result.error("ERROR", "Failed to show notification", e.message)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
