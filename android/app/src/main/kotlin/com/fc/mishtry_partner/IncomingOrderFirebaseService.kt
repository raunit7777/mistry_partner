//package com.fc.mishtry_partner
//import android.content.Context
//import android.content.Intent
//import android.media.MediaPlayer
//import android.media.RingtoneManager
//import android.os.Build
//import android.os.PowerManager
//import android.os.VibrationEffect
//import android.os.Vibrator
//import android.util.Log
//import com.google.firebase.messaging.FirebaseMessagingService
//import com.google.firebase.messaging.RemoteMessage
//import java.util.Locale
//
//class IncomingOrderFirebaseService : FirebaseMessagingService() {
//
//    private val tag = "IncomingOrderFCM"
//
//    override fun onNewToken(token: String) {
//        super.onNewToken(token)
//
//        Log.d(tag, "FCM Token: $token")
//
//        getSharedPreferences(
//            "rapido_fcm_prefs",
//            Context.MODE_PRIVATE
//        ).edit()
//            .putString("fcm_token", token)
//            .apply()
//    }
//
//    override fun onMessageReceived(remoteMessage: RemoteMessage) {
//        super.onMessageReceived(remoteMessage)
//
//        val payload = remoteMessage.data
//
//        Log.d(tag, "FCM Received: $payload")
//
//        val rawType = payload["type"]?.toString()
//        val type = rawType?.trim()?.lowercase(Locale.US)
//
//        val orderId =
//            payload["ride_id"]
//                ?: payload["rideId"]
//                ?: payload["order_id"]
//                ?: payload["booking_id"]
//                ?: payload["id"]
//                ?: ""
//
//        val userId = payload["user_id"] ?: ""
//
//        // Remove Order
//        if (
//            type == "remove_ride" ||
//            type == "remove_order" ||
//            type == "cancel_order" ||
//            type == "remove_service"
//        ) {
//
//            stopIncomingOrderAlert(this)
//
//            return
//        }
//
//        val isIncomingOrder =
//            type == "incoming_order" ||
//                    payload["incoming_order"] == "1"
//
//        val isIncomingServiceOrder =
//            type == "incoming_service_order" ||
//                    type == "new_service" ||
//                    type == "service_order" ||
//                    type == "service_booking" ||
//                    payload["incoming_service_order"] == "1"
//
//        if (!isIncomingOrder && !isIncomingServiceOrder) {
//            Log.d(tag, "Ignored notification type: $type")
//            return
//        }
//
//        val prefs = getSharedPreferences(
//            "rapido_online_prefs",
//            Context.MODE_PRIVATE
//        )
//
//        val isOnline =
//            prefs.getBoolean("is_online", false)
//
//        if (!isOnline) {
//            Log.d(tag, "User Offline - Ignore Incoming Order")
//            return
//        }
//
//        val pickup =
//            payload["pickup_address"]
//                ?: payload["service_address"]
//                ?: payload["address"]
//                ?: ""
//
//        val drop =
//            payload["drop_address"]
//                ?: payload["service_name"]
//                ?: payload["category_name"]
//                ?: "New Service Request"
//
//        val pickupDistance =
//            payload["pickup_distance_km"]
//                ?: payload["distance"]
//                ?: "0.0"
//
//        val rideDistance =
//            payload["distance_km"]
//                ?: "0.0"
//
//        val amount =
//            payload["amount"]
//                ?: payload["final_amount"]
//                ?: payload["total_amount"]
//                ?: "0"
//
//        val panel =
//            if (isIncomingServiceOrder)
//                "serviceman"
//            else
//                "driver"
//
//        startIncomingOrderAlert(this)
//
//        val powerManager =
//            getSystemService(Context.POWER_SERVICE) as PowerManager
//
//        val screenOn =
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
//                powerManager.isInteractive
//            } else {
//                @Suppress("DEPRECATION")
//                powerManager.isScreenOn
//            }
//
//        Log.d(
//            tag,
//            "Incoming Order => ScreenOn=$screenOn OrderId=$orderId"
//        )
//
//        if (!screenOn) {
//
//            wakeScreenBriefly()
//
//            val lockIntent = Intent(
//                this,
//                IncomingOrderLockScreenActivity::class.java
//            ).apply {
//
//                addFlags(
//                    Intent.FLAG_ACTIVITY_NEW_TASK or
//                            Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or
//                            Intent.FLAG_ACTIVITY_SINGLE_TOP
//                )
//
//                putExtra("order_id", orderId)
//                putExtra("user_id", userId)
//
//                putExtra("pickup_address", pickup)
//                putExtra("drop_address", drop)
//
//                putExtra(
//                    "pickup_distance_km",
//                    pickupDistance
//                )
//
//                putExtra(
//                    "distance_km",
//                    rideDistance
//                )
//
//                putExtra("amount", amount)
//                putExtra("panel", panel)
//            }
//
//            startActivity(lockIntent)
//
//        } else {
//
//            val overlayIntent = Intent(
//                this,
//                RapidoIncomingOrderOverlayService::class.java
//            ).apply {
//
//                action =
//                    RapidoIncomingOrderOverlayService.ACTION_SHOW_NOW
//
//                putExtra("pickup", pickup)
//                putExtra("drop", drop)
//
//                putExtra(
//                    "pickup_distance_km",
//                    pickupDistance
//                )
//
//                putExtra(
//                    "distance_km",
//                    rideDistance
//                )
//
//                putExtra("amount", amount)
//
//                putExtra("id", orderId)
//                putExtra("user_id", userId)
//
//                putExtra("panel", panel)
//
//                putExtra(
//                    "order_type",
//                    payload["order_type"]?.toIntOrNull() ?: 1
//                )
//
//                putExtra(
//                    "schedule_time",
//                    payload["schedule_time"] ?: ""
//                )
//            }
//
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                startForegroundService(overlayIntent)
//            } else {
//                startService(overlayIntent)
//            }
//        }
//    }
//
//    private fun wakeScreenBriefly() {
//
//        val pm =
//            getSystemService(Context.POWER_SERVICE) as PowerManager
//
//        @Suppress("DEPRECATION")
//        val wakeLock = pm.newWakeLock(
//            PowerManager.SCREEN_BRIGHT_WAKE_LOCK or
//                    PowerManager.ACQUIRE_CAUSES_WAKEUP,
//            "com.fc.mishtry_partner:incoming_order"
//        )
//
//        wakeLock.acquire(10_000L)
//    }
//
//    companion object {
//
//        const val ACTION_REMOVE_INCOMING_ORDER_UI =
//            "com.fc.mishtry_partner.ACTION_REMOVE_INCOMING_ORDER_UI"
//
//        private var mediaPlayer: MediaPlayer? = null
//        private var vibrator: Vibrator? = null
//
//        @Synchronized
//        fun startIncomingOrderAlert(context: Context) {
//
//            try {
//
//                val appContext =
//                    context.applicationContext
//
//                if (mediaPlayer?.isPlaying == true) {
//                    return
//                }
//
//                vibrator =
//                    appContext.getSystemService(
//                        Context.VIBRATOR_SERVICE
//                    ) as Vibrator
//
//                val pattern =
//                    longArrayOf(
//                        0,
//                        800,
//                        400,
//                        800
//                    )
//
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//
//                    vibrator?.vibrate(
//                        VibrationEffect.createWaveform(
//                            pattern,
//                            0
//                        )
//                    )
//
//                } else {
//
//                    @Suppress("DEPRECATION")
//                    vibrator?.vibrate(
//                        pattern,
//                        0
//                    )
//                }
//
//                mediaPlayer?.release()
//
//                val resId =
//                    appContext.resources.getIdentifier(
//                        "driver_rainbow",
//                        "raw",
//                        appContext.packageName
//                    )
//
//                mediaPlayer =
//                    if (resId != 0) {
//
//                        MediaPlayer.create(
//                            appContext,
//                            resId
//                        )
//
//                    } else {
//
//                        val uri =
//                            RingtoneManager.getDefaultUri(
//                                RingtoneManager.TYPE_ALARM
//                            )
//                                ?: RingtoneManager.getDefaultUri(
//                                    RingtoneManager.TYPE_NOTIFICATION
//                                )
//
//                        MediaPlayer().apply {
//                            setDataSource(
//                                appContext,
//                                uri
//                            )
//                            prepare()
//                        }
//                    }
//
//                mediaPlayer?.apply {
//                    isLooping = true
//                    start()
//                }
//
//            } catch (e: Exception) {
//
//                Log.e(
//                    "IncomingOrder",
//                    "startIncomingOrderAlert",
//                    e
//                )
//            }
//        }
//
//        @Synchronized
//        fun stopIncomingOrderAlert(context: Context) {
//
//            try {
//
//                mediaPlayer?.let {
//                    if (it.isPlaying) {
//                        it.stop()
//                    }
//                }
//
//                mediaPlayer?.release()
//                mediaPlayer = null
//
//                vibrator?.cancel()
//                vibrator = null
//
//                RapidoIncomingOrderOverlayService.start(
//                    context,
//                    RapidoIncomingOrderOverlayService.ACTION_HIDE
//                )
//
//                context.sendBroadcast(
//                    Intent(
//                        ACTION_REMOVE_INCOMING_ORDER_UI
//                    ).apply {
//                        setPackage(
//                            context.packageName
//                        )
//                    }
//                )
//
//            } catch (e: Exception) {
//
//                Log.e(
//                    "IncomingOrder",
//                    "stopIncomingOrderAlert",
//                    e
//                )
//            }
//        }
//    }
//}
//


package com.fc.mishtry_partner

import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Build
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import java.util.Locale

class IncomingOrderFirebaseService : FirebaseMessagingService() {

    private val tag = "IncomingOrderFCM"

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d(tag, "FCM Token: $token")
        getSharedPreferences("rapido_fcm_prefs", Context.MODE_PRIVATE)
            .edit().putString("fcm_token", token).apply()
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        val payload = remoteMessage.data
        Log.d(tag, "FCM Received: $payload")

        val rawType = payload["type"]?.toString()
        val type = rawType?.trim()?.lowercase(Locale.US)

        val orderId = payload["ride_id"]
            ?: payload["rideId"]
            ?: payload["order_id"]
            ?: payload["booking_id"]
            ?: payload["id"]
            ?: ""

        val userId = payload["user_id"] ?: ""

        // ===== REMOVE / CANCEL =====
        if (type == "remove_ride" || type == "remove_order" ||
            type == "cancel_order" || type == "remove_service" ||
            type == "cancel_booking") {
            Log.d(tag, "Cancel order received - stopping alert")
            stopIncomingOrderAlert(this)
            return
        }

        // ===== TYPE CHECK =====
        val isIncomingOrder =
            type == "incoming_order" ||
                    payload["incoming_order"] == "1"

        val isIncomingServiceOrder =
            type == "incoming_service_order" ||
                    type == "new_service" ||
                    type == "service_order" ||
                    type == "service_booking" ||
                    payload["incoming_service_order"] == "1"

        // ✅ new_booking type
        val isNewBooking =
            type == "new_booking" ||
                    type == "new_order" ||
                    type == "new_booking_nearby"

        // ✅ show_overlay check - sirf "true" string hone par dikhao
        val showOverlay = payload["show_overlay"]?.toString()?.lowercase(Locale.US) == "true"

        val shouldShow = when {
            isIncomingOrder -> true
            isIncomingServiceOrder -> true
            isNewBooking -> showOverlay
            else -> false
        }

        if (!shouldShow) {
            Log.d(tag, "Ignored - type=$type showOverlay=$showOverlay")
            return
        }

        // ===== ONLINE CHECK =====
        val isOnline = getSharedPreferences("rapido_online_prefs", Context.MODE_PRIVATE)
            .getBoolean("is_online", false)

        if (!isOnline) {
            Log.d(tag, "User Offline - ignoring")
            return
        }

        // ===== EXTRACT DATA =====
        val pickup = payload["pickup_address"]
            ?: payload["service_address"]
            ?: payload["address"]
            ?: ""

        val drop = payload["drop_address"]
            ?: payload["service_name"]
            ?: payload["category_name"]
            ?: "New Booking"

        val pickupDistance = payload["pickup_distance_km"]
            ?: payload["distance"]
            ?: "0.0"

        val rideDistance = payload["distance_km"] ?: "0.0"

        val amount = payload["amount"]
            ?: payload["service_price"]
            ?: payload["final_amount"]
            ?: payload["total_amount"]
            ?: "0"

        val panel = if (isIncomingServiceOrder || isNewBooking) "serviceman" else "driver"

        Log.d(tag, "Showing order: id=$orderId amount=$amount panel=$panel")

        startIncomingOrderAlert(this)

        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        val screenOn = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
            powerManager.isInteractive
        } else {
            @Suppress("DEPRECATION")
            powerManager.isScreenOn
        }

        Log.d(tag, "ScreenOn=$screenOn")

        if (!screenOn) {
            wakeScreenBriefly()

            val lockIntent = Intent(this, IncomingOrderLockScreenActivity::class.java).apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
                putExtra("order_id", orderId)
                putExtra("user_id", userId)
                putExtra("pickup_address", pickup)
                putExtra("drop_address", drop)
                putExtra("pickup_distance_km", pickupDistance)
                putExtra("distance_km", rideDistance)
                putExtra("amount", amount)
                putExtra("panel", panel)
            }
            startActivity(lockIntent)

        } else {
            val overlayIntent = Intent(this, RapidoIncomingOrderOverlayService::class.java).apply {
                action = RapidoIncomingOrderOverlayService.ACTION_SHOW_NOW
                putExtra("pickup", pickup)
                putExtra("drop", drop)
                putExtra("pickup_distance_km", pickupDistance)
                putExtra("distance_km", rideDistance)
                putExtra("amount", amount)
                putExtra("id", orderId)
                putExtra("user_id", userId)
                putExtra("panel", panel)
                putExtra("order_type", payload["order_type"]?.toIntOrNull() ?: 1)
                putExtra("schedule_time", payload["schedule_time"] ?: "")
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(overlayIntent)
            } else {
                startService(overlayIntent)
            }
        }
    }

    private fun wakeScreenBriefly() {
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        @Suppress("DEPRECATION")
        val wakeLock = pm.newWakeLock(
            PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "com.fc.mishtry_partner:incoming_order"
        )
        wakeLock.acquire(15_000L)
        android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
            try { if (wakeLock.isHeld) wakeLock.release() } catch (e: Exception) { /* ignore */ }
        }, 12_000L)
    }

    companion object {

        const val ACTION_REMOVE_INCOMING_ORDER_UI =
            "com.fc.namaste_eats_vendor.ACTION_REMOVE_INCOMING_ORDER_UI"

        private var mediaPlayer: MediaPlayer? = null
        private var vibrator: Vibrator? = null

        @Synchronized
        fun startIncomingOrderAlert(context: Context) {
            try {
                val appContext = context.applicationContext
                if (mediaPlayer?.isPlaying == true) return

                vibrator = appContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                val pattern = longArrayOf(0, 800, 400, 800)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    vibrator?.vibrate(VibrationEffect.createWaveform(pattern, 0))
                } else {
                    @Suppress("DEPRECATION")
                    vibrator?.vibrate(pattern, 0)
                }

                mediaPlayer?.release()
                val resId = appContext.resources.getIdentifier(
                    "driver_rainbow", "raw", appContext.packageName
                )
                mediaPlayer = if (resId != 0) {
                    MediaPlayer.create(appContext, resId)
                } else {
                    val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                        ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                    MediaPlayer().apply { setDataSource(appContext, uri); prepare() }
                }
                mediaPlayer?.apply { isLooping = true; start() }

            } catch (e: Exception) {
                Log.e("IncomingOrder", "startAlert error", e)
            }
        }

        @Synchronized
        fun stopIncomingOrderAlert(context: Context) {
            try {
                mediaPlayer?.let { if (it.isPlaying) it.stop() }
                mediaPlayer?.release()
                mediaPlayer = null
                vibrator?.cancel()
                vibrator = null
                RapidoIncomingOrderOverlayService.start(context, RapidoIncomingOrderOverlayService.ACTION_HIDE)
                context.sendBroadcast(Intent(ACTION_REMOVE_INCOMING_ORDER_UI).apply {
                    setPackage(context.packageName)
                })
            } catch (e: Exception) {
                Log.e("IncomingOrder", "stopAlert error", e)
            }
        }
    }
}