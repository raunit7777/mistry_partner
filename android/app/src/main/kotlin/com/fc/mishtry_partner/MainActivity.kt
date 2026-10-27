//package com.fc.mishtry_partner
//
//import android.content.Context
//import android.content.pm.PackageManager
//import android.content.Intent
//import android.net.Uri
//import android.os.Build
//import android.os.Bundle
//import android.os.PowerManager
//import android.provider.Settings
//import android.util.Log
//import android.view.WindowManager
//import androidx.annotation.UiThread
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity : FlutterActivity() {
//    private val channelName = "rapido_background_button"
//    private val tag = "RapidoOverlay"
//    private var channel: MethodChannel? = null
//    // true if EITHER driver or serviceman is online
//    private var isOnlineFromFlutter: Boolean = false
//    private var pendingNotificationPermissionResult: MethodChannel.Result? = null
//    private val REQUEST_CODE_POST_NOTIFICATIONS = 1001
//
//    private val prefsName = "rapido_online_prefs"
//    private val prefsKeyIsOnline = "is_online"
//    private val prefsKeyDriverOnline = "is_driver_online"
//    private val prefsKeyServicemanOnline = "is_serviceman_online"
//
//    // track each panel independently so bubble shows when either is online
//    private var isDriverOnline: Boolean = false
//    private var isServicemanOnline: Boolean = false
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        // Restore online state from SharedPreferences
//        val prefs = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
//        isOnlineFromFlutter = prefs.getBoolean(prefsKeyIsOnline, false)
//        isDriverOnline = prefs.getBoolean(prefsKeyDriverOnline, false)
//        isServicemanOnline = prefs.getBoolean(prefsKeyServicemanOnline, false)
//
//        Log.d(tag, "onCreate: Restored status - Online: $isOnlineFromFlutter, Driver: $isDriverOnline, Serviceman: $isServicemanOnline")
//
//        // Remove setShowWhenLocked so it forces system unlock prompt when started from background
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
//            setTurnScreenOn(true)
//        } else {
//            @Suppress("DEPRECATION")
//            window.addFlags(
//                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
//                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
//                        WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
//            )
//        }
//    }
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
//        channel = methodChannel
//        methodChannel.setMethodCallHandler { call, result ->
//            when (call.method) {
//                "setOnline" -> {
//                    val online = (call.argument<Boolean>("online") ?: false)
//                    setOnlineState(online)
//                    result.success(null)
//                }
//
//                "setDriverOnline" -> {
//                    isDriverOnline = call.argument<Boolean>("online") ?: false
//                    getSharedPreferences(prefsName, Context.MODE_PRIVATE).edit().putBoolean(prefsKeyDriverOnline, isDriverOnline).apply()
//                    setOnlineState(isDriverOnline || isServicemanOnline)
//                    result.success(null)
//                }
//
//                "setServicemanOnline" -> {
//                    isServicemanOnline = call.argument<Boolean>("online") ?: false
//                    getSharedPreferences(prefsName, Context.MODE_PRIVATE).edit().putBoolean(prefsKeyServicemanOnline, isServicemanOnline).apply()
//                    setOnlineState(isDriverOnline || isServicemanOnline)
//                    result.success(null)
//                }
//
//                "scheduleIncomingOrderOverlay" -> {
//
//                    val delayMs = call.argument<Number>("delayMs")?.toLong()
//                        ?: RapidoIncomingOrderOverlayService.DEFAULT_DELAY_MS
//
//                    // ✅ Overlay sirf screen ON mein schedule ho.
//                    val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
//                    val screenOn = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
//                        pm.isInteractive
//                    } else {
//                        @Suppress("DEPRECATION")
//                        pm.isScreenOn
//                    }
//                    if (!screenOn) {
//                        Log.d(tag, "scheduleIncomingOrderOverlay: screen is OFF → ignoring overlay schedule")
//                        result.success(false)
//                        return@setMethodCallHandler
//                    }
//
//                    val pickup = call.argument<String>("pickup") ?: ""
//                    val drop = call.argument<String>("drop") ?: ""
//                    // Check for both keys
//                    val distance = call.argument<String>("pickup_distance_km")
//                        ?: call.argument<String>("distance")
//                        ?: ""
//                    val id = call.argument<String>("id")
//                        ?: call.argument<String>("orderId")
//                        ?: ""
//                    val amount = call.argument<String>("amount") ?: ""
//
//                    val intent = Intent(this, RapidoIncomingOrderOverlayService::class.java).apply {
//                        action = RapidoIncomingOrderOverlayService.ACTION_SCHEDULE_SHOW
//                        putExtra("pickup", pickup)
//                        putExtra("drop", drop)
//                        putExtra("pickup_distance_km", distance)
//                        putExtra("distance", distance)
//                        putExtra("id", id)
//                        putExtra("amount", amount)
//                        putExtra(RapidoIncomingOrderOverlayService.EXTRA_DELAY_MS, delayMs)
//                    }
//
//                    startService(intent)
//                    result.success(true)
//                }
//
//                "cancelIncomingOrderOverlay" -> {
//                    RapidoIncomingOrderOverlayService.start(this, RapidoIncomingOrderOverlayService.ACTION_HIDE)
//                    result.success(null)
//                }
//
//                "stopIncomingOrderAlert" -> {
//                    IncomingOrderFirebaseService.stopIncomingOrderAlert(this)
//                    result.success(null)
//                }
//
//                "hasOverlayPermission" -> {
//                    val has = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                        Settings.canDrawOverlays(this)
//                    } else {
//                        true
//                    }
//                    result.success(has)
//                }
//
//                "getLaunchRoute" -> {
//                    val route = consumeRouteFromIntent(intent)
//                    // These are native action keys, not Flutter route names — avoid pushNamed("accept_ride_action") → "No Route Found".
//                    if (route == RapidoIncomingOrderOverlayService.ROUTE_ACCEPT_RIDE ||
//                        route == RapidoIncomingOrderOverlayService.ROUTE_IGNORE_RIDE
//                    ) {
//                        dispatchOverlayAcceptIgnore(route, intent)
//                        result.success(null)
//                    } else {
//                        result.success(route)
//                    }
//                }
//
//                "getFirebaseToken" -> {
//                    val token = getSharedPreferences("rapido_fcm_prefs", Context.MODE_PRIVATE)
//                        .getString("fcm_token", null)
//                    result.success(token)
//                }
//
//                "requestPermissions" -> {
//                    // Android overlay permission cannot be granted via runtime popup.
//                    // We can only navigate user to the system settings page.
//                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
//                        val intent = Intent(
//                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                            Uri.parse("package:$packageName")
//                        )
//                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//                        startActivity(intent)
//                    }
//                    result.success(null)
//                }
//
//                "hasNotificationPermission" -> {
//                    val hasPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
//                        checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
//                    } else {
//                        true
//                    }
//                    result.success(hasPermission)
//                }
//
//                "requestNotificationPermission" -> {
//                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
//                        result.success(true)
//                        return@setMethodCallHandler
//                    }
//
//                    val hasPermission = checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
//                    if (hasPermission) {
//                        result.success(true)
//                        return@setMethodCallHandler
//                    }
//
//                    if (pendingNotificationPermissionResult != null) {
//                        result.error("pending_request", "Notification permission request already in progress", null)
//                        return@setMethodCallHandler
//                    }
//
//                    pendingNotificationPermissionResult = result
//                    requestPermissions(arrayOf(android.Manifest.permission.POST_NOTIFICATIONS), REQUEST_CODE_POST_NOTIFICATIONS)
//                }
//
//                "showBackgroundButton" -> {
//                    val has = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                        Settings.canDrawOverlays(this)
//                    } else {
//                        true
//                    }
//                    if (has) {
//                        RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_SHOW)
//                    }
//                    result.success(has)
//                }
//
//                "hideBackgroundButton" -> {
//                    RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_HIDE)
//                    result.success(null)
//                }
//
//                else -> result.notImplemented()
//            }
//        }
//    }
//
//    private fun setOnlineState(online: Boolean) {
//        isOnlineFromFlutter = online
//        getSharedPreferences(prefsName, Context.MODE_PRIVATE)
//            .edit()
//            .putBoolean(prefsKeyIsOnline, online)
//            .apply()
//        Log.d(tag, "setOnlineState: $online")
//    }
//
//    // Called by native overlay when user accepts/ignores from overlay card
//    fun dispatchOverlayEvent(method: String, data: Map<String, String>) {
//        try {
//            channel?.invokeMethod(method, data)
//        } catch (t: Throwable) {
//            Log.w(tag, "dispatchOverlayEvent $method failed", t)
//        }
//    }
//
//    override fun onNewIntent(intent: Intent) {
//        super.onNewIntent(intent)
//        setIntent(intent)
//
//        val route = consumeRouteFromIntent(intent) ?: return
//        try {
//            if (route == RapidoIncomingOrderOverlayService.ROUTE_ACCEPT_RIDE ||
//                route == RapidoIncomingOrderOverlayService.ROUTE_IGNORE_RIDE
//            ) {
//                dispatchOverlayAcceptIgnore(route, intent)
//                return
//            }
//
//            channel?.invokeMethod("navigateTo", route)
//        } catch (t: Throwable) {
//            Log.w(tag, "Failed to invoke navigateTo($route)", t)
//        }
//    }
//
//    private fun dispatchOverlayAcceptIgnore(route: String, intent: Intent) {
//        val orderId = intent.getStringExtra(RapidoIncomingOrderOverlayService.EXTRA_ORDER_ID) ?: ""
//        if (orderId.isBlank()) return
//        val panel = intent.getStringExtra("panel") ?: "driver"
//
//        if (route == RapidoIncomingOrderOverlayService.ROUTE_ACCEPT_RIDE) {
//            val pickup = intent.getStringExtra("pickup_address") ?: ""
//            val drop = intent.getStringExtra("drop_address") ?: ""
//            val distance = intent.getStringExtra("distance") ?: ""
//            val distanceKm = intent.getStringExtra("distance_km") ?: ""
//            val amount = intent.getStringExtra("amount") ?: ""
//            val userId = intent.getStringExtra("user_id") ?: ""
//            val orderType = intent.getIntExtra("order_type", 1)
//            val scheduleTime = intent.getStringExtra("schedule_time") ?: ""
//
//            val data = mapOf(
//                "id" to orderId,
//                "pickup_address" to pickup,
//                "drop_address" to drop,
//                "distance" to distance,
//                "distance_km" to distanceKm,
//                "amount" to amount,
//                "panel" to panel,
//                "user_id" to userId,
//                "order_type" to orderType.toString(),
//                "schedule_time" to scheduleTime,
//            )
//            channel?.invokeMethod("onOverlayAcceptRide", data)
//        } else {
//            val data = mapOf("id" to orderId, "panel" to panel)
//            channel?.invokeMethod("onOverlayIgnoreRide", data)
//        }
//    }
//
//    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
//        if (requestCode == REQUEST_CODE_POST_NOTIFICATIONS) {
//            val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
//            pendingNotificationPermissionResult?.success(granted)
//            pendingNotificationPermissionResult = null
//        }
//    }
//
//    private fun consumeRouteFromIntent(intent: Intent?): String? {
//        if (intent == null) return null
//        val route = intent.getStringExtra(RapidoIncomingOrderOverlayService.EXTRA_NAV_ROUTE)
//        if (route.isNullOrBlank()) return null
//        // Avoid re-navigation on config changes.
//        intent.removeExtra(RapidoIncomingOrderOverlayService.EXTRA_NAV_ROUTE)
//        return route
//    }
//
//    override fun onPause() {
//        super.onPause()
//
//        Log.d(tag, "onPause: canDrawOverlays=${Settings.canDrawOverlays(this)}, isOnlineFromFlutter=$isOnlineFromFlutter")
//
//        // If overlay permission is missing, do nothing here.
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) return
//
//        // Respect Flutter ONLINE/OFFLINE.
//        if (!isOnlineFromFlutter) return
//
//        // App is going to background: show the bubble.
//        Log.d(tag, "Starting overlay service: SHOW")
//        RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_SHOW)
//    }
//
//    override fun onResume() {
//        super.onResume()
//        // App is in foreground: hide bubble.
//        Log.d(tag, "onResume: Starting overlay service: HIDE")
//        RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_HIDE)
//        RapidoIncomingOrderOverlayService.start(this, RapidoIncomingOrderOverlayService.ACTION_HIDE)
//        IncomingOrderNotification.cancel(this)
//    }
//}
//
//


package com.fc.mishtry_partner

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.view.WindowManager
import androidx.annotation.UiThread
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "rapido_background_button"
    private val tag = "RapidoOverlay"
    private var channel: MethodChannel? = null
    private var isOnlineFromFlutter: Boolean = false
    private var pendingNotificationPermissionResult: MethodChannel.Result? = null
    private val REQUEST_CODE_POST_NOTIFICATIONS = 1001

    private val prefsName = "rapido_online_prefs"
    private val prefsKeyIsOnline = "is_online"
    private val prefsKeyDriverOnline = "is_driver_online"
    private val prefsKeyServicemanOnline = "is_serviceman_online"

    private var isDriverOnline: Boolean = false
    private var isServicemanOnline: Boolean = false

    // ✅ Delay wala bubble show — false positive onPause rok'ta hai
    private var bubbleShowRunnable: Runnable? = null
    private val bubbleHandler = Handler(Looper.getMainLooper())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val prefs = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
        isOnlineFromFlutter = prefs.getBoolean(prefsKeyIsOnline, false)
        isDriverOnline = prefs.getBoolean(prefsKeyDriverOnline, false)
        isServicemanOnline = prefs.getBoolean(prefsKeyServicemanOnline, false)

        Log.d(tag, "onCreate: Online=$isOnlineFromFlutter Driver=$isDriverOnline Serviceman=$isServicemanOnline")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                        WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        channel = methodChannel
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "setOnline" -> {
                    val online = call.argument<Boolean>("online") ?: false
                    setOnlineState(online)
                    result.success(null)
                }

                "setDriverOnline" -> {
                    isDriverOnline = call.argument<Boolean>("online") ?: false
                    getSharedPreferences(prefsName, Context.MODE_PRIVATE).edit()
                        .putBoolean(prefsKeyDriverOnline, isDriverOnline).apply()
                    setOnlineState(isDriverOnline || isServicemanOnline)
                    result.success(null)
                }

                "setServicemanOnline" -> {
                    isServicemanOnline = call.argument<Boolean>("online") ?: false
                    getSharedPreferences(prefsName, Context.MODE_PRIVATE).edit()
                        .putBoolean(prefsKeyServicemanOnline, isServicemanOnline).apply()
                    setOnlineState(isDriverOnline || isServicemanOnline)
                    result.success(null)
                }

                "scheduleIncomingOrderOverlay" -> {
                    val delayMs = call.argument<Number>("delayMs")?.toLong()
                        ?: RapidoIncomingOrderOverlayService.DEFAULT_DELAY_MS

                    val pm = getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
                    val screenOn = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
                        pm.isInteractive
                    } else {
                        @Suppress("DEPRECATION")
                        pm.isScreenOn
                    }
                    if (!screenOn) {
                        Log.d(tag, "scheduleIncomingOrderOverlay: screen OFF → skip")
                        result.success(false)
                        return@setMethodCallHandler
                    }

                    val pickup = call.argument<String>("pickup") ?: ""
                    val drop = call.argument<String>("drop") ?: ""
                    val distance = call.argument<String>("pickup_distance_km")
                        ?: call.argument<String>("distance") ?: ""
                    val id = call.argument<String>("id")
                        ?: call.argument<String>("orderId") ?: ""
                    val amount = call.argument<String>("amount") ?: ""

                    val intent = Intent(this, RapidoIncomingOrderOverlayService::class.java).apply {
                        action = RapidoIncomingOrderOverlayService.ACTION_SCHEDULE_SHOW
                        putExtra("pickup", pickup)
                        putExtra("drop", drop)
                        putExtra("pickup_distance_km", distance)
                        putExtra("distance", distance)
                        putExtra("id", id)
                        putExtra("amount", amount)
                        putExtra(RapidoIncomingOrderOverlayService.EXTRA_DELAY_MS, delayMs)
                    }
                    startService(intent)
                    result.success(true)
                }

                "cancelIncomingOrderOverlay" -> {
                    RapidoIncomingOrderOverlayService.start(this, RapidoIncomingOrderOverlayService.ACTION_HIDE)
                    result.success(null)
                }

                "stopIncomingOrderAlert" -> {
                    IncomingOrderFirebaseService.stopIncomingOrderAlert(this)
                    result.success(null)
                }

                "hasOverlayPermission" -> {
                    val has = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        Settings.canDrawOverlays(this)
                    } else true
                    result.success(has)
                }

                "getLaunchRoute" -> {
                    val route = consumeRouteFromIntent(intent)
                    if (route == RapidoIncomingOrderOverlayService.ROUTE_ACCEPT_RIDE ||
                        route == RapidoIncomingOrderOverlayService.ROUTE_IGNORE_RIDE
                    ) {
                        dispatchOverlayAcceptIgnore(route, intent)
                        result.success(null)
                    } else {
                        result.success(route)
                    }
                }

                "getFirebaseToken" -> {
                    val token = getSharedPreferences("rapido_fcm_prefs", Context.MODE_PRIVATE)
                        .getString("fcm_token", null)
                    result.success(token)
                }

                "requestPermissions" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            Uri.parse("package:$packageName")
                        ).apply { addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) }
                        startActivity(intent)
                    }
                    result.success(null)
                }

                "hasNotificationPermission" -> {
                    val hasPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
                    } else true
                    result.success(hasPermission)
                }

                "requestNotificationPermission" -> {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                        result.success(true)
                        return@setMethodCallHandler
                    }
                    val hasPermission = checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
                    if (hasPermission) {
                        result.success(true)
                        return@setMethodCallHandler
                    }
                    if (pendingNotificationPermissionResult != null) {
                        result.error("pending_request", "Already in progress", null)
                        return@setMethodCallHandler
                    }
                    pendingNotificationPermissionResult = result
                    requestPermissions(
                        arrayOf(android.Manifest.permission.POST_NOTIFICATIONS),
                        REQUEST_CODE_POST_NOTIFICATIONS
                    )
                }

                "showBackgroundButton" -> {
                    val has = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        Settings.canDrawOverlays(this)
                    } else true
                    if (has) {
                        RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_SHOW)
                    }
                    result.success(has)
                }

                "hideBackgroundButton" -> {
                    RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_HIDE)
                    result.success(null)
                }

                "goOnline" -> {
                    setOnlineState(true)
                    result.success(null)
                }

                "goOffline" -> {
                    setOnlineState(false)
                    RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_HIDE)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun setOnlineState(online: Boolean) {
        isOnlineFromFlutter = online
        getSharedPreferences(prefsName, Context.MODE_PRIVATE)
            .edit().putBoolean(prefsKeyIsOnline, online).apply()
        Log.d(tag, "setOnlineState: $online")
    }

    fun dispatchOverlayEvent(method: String, data: Map<String, String>) {
        try {
            channel?.invokeMethod(method, data)
        } catch (t: Throwable) {
            Log.w(tag, "dispatchOverlayEvent $method failed", t)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)

        val route = consumeRouteFromIntent(intent) ?: return
        try {
            if (route == RapidoIncomingOrderOverlayService.ROUTE_ACCEPT_RIDE ||
                route == RapidoIncomingOrderOverlayService.ROUTE_IGNORE_RIDE
            ) {
                dispatchOverlayAcceptIgnore(route, intent)
                return
            }
            channel?.invokeMethod("navigateTo", route)
        } catch (t: Throwable) {
            Log.w(tag, "Failed to invoke navigateTo($route)", t)
        }
    }

    private fun dispatchOverlayAcceptIgnore(route: String, intent: Intent) {
        val orderId = intent.getStringExtra(RapidoIncomingOrderOverlayService.EXTRA_ORDER_ID) ?: ""
        if (orderId.isBlank()) return
        val panel = intent.getStringExtra("panel") ?: "driver"

        if (route == RapidoIncomingOrderOverlayService.ROUTE_ACCEPT_RIDE) {
            val data = mapOf(
                "id"             to orderId,
                "pickup_address" to (intent.getStringExtra("pickup_address") ?: ""),
                "drop_address"   to (intent.getStringExtra("drop_address") ?: ""),
                "distance"       to (intent.getStringExtra("distance") ?: ""),
                "distance_km"    to (intent.getStringExtra("distance_km") ?: ""),
                "amount"         to (intent.getStringExtra("amount") ?: ""),
                "panel"          to panel,
                "user_id"        to (intent.getStringExtra("user_id") ?: ""),
                "order_type"     to intent.getIntExtra("order_type", 1).toString(),
                "schedule_time"  to (intent.getStringExtra("schedule_time") ?: ""),
            )
            channel?.invokeMethod("onOverlayAcceptRide", data)
        } else {
            val data = mapOf("id" to orderId, "panel" to panel)
            channel?.invokeMethod("onOverlayIgnoreRide", data)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE_POST_NOTIFICATIONS) {
            val granted = grantResults.isNotEmpty() &&
                    grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingNotificationPermissionResult?.success(granted)
            pendingNotificationPermissionResult = null
        }
    }

    private fun consumeRouteFromIntent(intent: Intent?): String? {
        if (intent == null) return null
        val route = intent.getStringExtra(RapidoIncomingOrderOverlayService.EXTRA_NAV_ROUTE)
        if (route.isNullOrBlank()) return null
        intent.removeExtra(RapidoIncomingOrderOverlayService.EXTRA_NAV_ROUTE)
        return route
    }

    override fun onPause() {
        super.onPause()
        Log.d(tag, "onPause: isOnline=$isOnlineFromFlutter")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) return
        if (!isOnlineFromFlutter) return

        bubbleShowRunnable?.let { bubbleHandler.removeCallbacks(it) }

        val runnable = Runnable {
            if (!isOnlineFromFlutter) return@Runnable
            Log.d(tag, "onPause delayed → showing bubble")
            RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_SHOW)
        }
        bubbleShowRunnable = runnable
        bubbleHandler.postDelayed(runnable, 600L)
    }

    override fun onResume() {
        super.onResume()

        bubbleShowRunnable?.let { bubbleHandler.removeCallbacks(it) }
        bubbleShowRunnable = null

        Log.d(tag, "onResume: hiding bubble overlay only")
        // ✅ ACTION_HIDE — sirf view hatao, service band nahi hogi
        RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_HIDE)
        RapidoIncomingOrderOverlayService.start(this, RapidoIncomingOrderOverlayService.ACTION_HIDE)
        IncomingOrderNotification.cancel(this)
    }

    override fun onDestroy() {
        // ✅ Memory leak se bachao
        bubbleShowRunnable?.let { bubbleHandler.removeCallbacks(it) }
        bubbleShowRunnable = null
        super.onDestroy()
    }
}
