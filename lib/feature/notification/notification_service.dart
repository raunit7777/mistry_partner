// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // // import 'package:fasto_partner/utils/routes/routes_name.dart';
// //
// //
// // @pragma('vm:entry-point')
// // void notificationTapBackground(NotificationResponse notificationResponse) {
// //   debugPrint('--- 🌙 Background Tap ---');
// //   SoundHelper2.stop(); // Tap hote hi sound band
// // }
// //
// // class NotificationService {
// //   static final NotificationService _instance = NotificationService._internal();
// //   factory NotificationService() => _instance;
// //   NotificationService._internal();
// //
// //   final FlutterLocalNotificationsPlugin _localPlugin = FlutterLocalNotificationsPlugin();
// //   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
// //
// //   // 🔥 FIX 1: Channel ID badal diya (Android naya channel create karega fresh settings ke saath)
// //   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
// //     'order_alert_channel_v2',
// //     'Order Notifications',
// //     importance: Importance.max,
// //     playSound: true, // System sound enable
// //     enableVibration: true,
// //     showBadge: true,
// //   );
// //
// //   Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
// //     // resolve implementation and create channel
// //     await _localPlugin
// //         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
// //         ?.createNotificationChannel(_channel);
// //
// //     // Permission request with sound true
// //     await _messaging.requestPermission(
// //       alert: true,
// //       badge: true,
// //       sound: true,
// //       criticalAlert: true, // iOS critical sound support
// //     );
// //
// //     const initializationSettings = InitializationSettings(
// //       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
// //       iOS: DarwinInitializationSettings(),
// //     );
// //
// //     await _localPlugin.initialize(
// //       settings: initializationSettings,
// //       onDidReceiveNotificationResponse: (NotificationResponse details) {
// //         debugPrint("--- 👆 Notification Clicked ---");
// //         SoundHelper2.stop(); // Sound band karein
// //         navigatorKey.currentState?.pushNamed(RoutesName.notificationScreen);
// //       },
// //       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
// //     );
// //
// //     _setupListeners(navigatorKey);
// //   }
// //
// //   void _setupListeners(GlobalKey<NavigatorState> navigatorKey) {
// //     // 1. FOREGROUND MESSAGE
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       debugPrint("--- ⚡ Incoming Message Data: ${message.data} ---");
// //
// //       // 🔥 FIX 2: Type '1' (New Order) ke liye SoundHelper call
// //       if (message.data['type']?.toString() == '1') {
// //         SoundHelper2.playClick(); // Aapka custom long ringtone
// //
// //         // Auto Navigation (Optional: Agar aap chahte hain bina click kiye Home par jaye)
// //         navigatorKey.currentState?.pushNamed(RoutesName.homeScreen);
// //       }
// //
// //       RemoteNotification? notification = message.notification;
// //       AndroidNotification? android = message.notification?.android;
// //
// //       if (notification != null) {
// //         _localPlugin.show(
// //           id: notification.hashCode,
// //           title: notification.title,
// //           body: notification.body,
// //           notificationDetails: NotificationDetails(
// //             android: AndroidNotificationDetails(
// //               _channel.id,
// //               _channel.name,
// //               icon: android?.smallIcon ?? '@mipmap/ic_launcher',
// //               importance: Importance.max,
// //               priority: Priority.high,
// //               playSound: true, // Force system beep/sound
// //               // sound: RawResourceAndroidNotificationSound('notification_sound'), // Agar raw folder mein sound hai
// //             ),
// //             iOS: const DarwinNotificationDetails(
// //               presentSound: true,
// //               presentAlert: true,
// //               presentBadge: true,
// //             ),
// //           ),
// //           payload: jsonEncode(message.data),
// //         );
// //       }
// //     });
// //
// //     // 2. BACKGROUND TAP
// //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       SoundHelper2.stop();
// //       if (message.data['type']?.toString() == '1') {
// //         navigatorKey.currentState?.pushNamed(RoutesName.homeScreen);
// //       }
// //     });
// //
// //     // 3. TERMINATED STATE
// //     _messaging.getInitialMessage().then((RemoteMessage? message) {
// //       if (message != null) {
// //         SoundHelper2.stop();
// //         Future.delayed(const Duration(milliseconds: 500), () {
// //           if (message.data['type']?.toString() == '1') {
// //             navigatorKey.currentState?.pushNamed(RoutesName.homeScreen);
// //           }
// //         });
// //       }
// //     });
// //   }
// // }
//
// import 'dart:async';
// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   debugPrint('--- 🌙 Background Tap ---');
// }
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
// // FCM Token fetch karne ke liye method
//   Future<String?> getDeviceToken() async {
//     try {
//       String? token = await _messaging.getToken();
//       debugPrint("🔥 FCM Token: $token");
//       return token;
//     } catch (e) {
//       debugPrint("Error fetching token: $e");
//       return null;
//     }
//   }
//   final FlutterLocalNotificationsPlugin _localPlugin = FlutterLocalNotificationsPlugin();
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//
//   // Sound aur Vibration disable kar diya gaya hai
//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'order_alert_channel_v3', // Naya channel ID
//     'Order Notifications',
//     importance: Importance.max,
//     playSound: false,
//     enableVibration: false,
//     showBadge: true,
//   );
//
//   Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
//     await _localPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_channel);
//
//     await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: false,
//       criticalAlert: false,
//     );
//
//     const initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       iOS: DarwinInitializationSettings(
//         requestSoundPermission: false,
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//       ),
//     );
//
//     await _localPlugin.initialize(
//       settings: initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse details) {
//         debugPrint("--- 👆 Notification Clicked ---");
//         // navigatorKey.currentState?.pushNamed(RoutesName.notificationScreen); // Uncomment if needed
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );
//
//     _setupListeners(navigatorKey);
//   }
//
//   void _setupListeners(GlobalKey<NavigatorState> navigatorKey) {
//     // 1. FOREGROUND MESSAGE
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("--- ⚡ Incoming Message Data: ${message.data} ---");
//
//       if (message.data['type']?.toString() == '1') {
//         // navigatorKey.currentState?.pushNamed(RoutesName.homeScreen); // Uncomment if needed
//       }
//
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//
//       if (notification != null) {
//         _localPlugin.show(
//           id: notification.hashCode,
//           title: notification.title,
//           body: notification.body,
//           notificationDetails: NotificationDetails(
//             android: AndroidNotificationDetails(
//               _channel.id,
//               _channel.name,
//               icon: android?.smallIcon ?? '@mipmap/ic_launcher',
//               importance: Importance.max,
//               priority: Priority.high,
//               playSound: false,
//               enableVibration: false,
//             ),
//             iOS: const DarwinNotificationDetails(
//               presentSound: false,
//               presentAlert: true,
//               presentBadge: true,
//             ),
//           ),
//           payload: jsonEncode(message.data),
//         );
//       }
//     });
//
//     // 2. BACKGROUND TAP
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (message.data['type']?.toString() == '1') {
//         // navigatorKey.currentState?.pushNamed(RoutesName.homeScreen); // Uncomment if needed
//       }
//     });
//
//     // 3. TERMINATED STATE
//     _messaging.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         Future.delayed(const Duration(milliseconds: 500), () {
//           if (message.data['type']?.toString() == '1') {
//             // navigatorKey.currentState?.pushNamed(RoutesName.homeScreen); // Uncomment if needed
//           }
//         });
//       }
//     });
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mishtry_partner/feature/auth/view_model/login_view_mode.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('--- Background Tap ---');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Native channel - overlay call ke liye
  static const _nativeChannel = MethodChannel('rapido_background_button');

  Future<String?> getDeviceToken() async {

    try {
      String? token = await _messaging.getToken();
      debugPrint("FCM Token: $token");

      return token;
    } catch (e) {
      debugPrint("Error fetching token: $e");
      return null;
    }
  }

  final FlutterLocalNotificationsPlugin _localPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Sound/Vibration OFF - native side handle karta hai
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'order_alert_channel_v3',
    'Order Notifications',
    importance: Importance.max,
    playSound: false,
    enableVibration: false,
    showBadge: true,
  );

  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    await _localPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: false,
      criticalAlert: false,
    );

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: false,
        requestAlertPermission: true,
        requestBadgePermission: true,
      ),
    );

    await _localPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint("Notification Clicked");
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _setupListeners(navigatorKey);
  }

  void _setupListeners(GlobalKey<NavigatorState> navigatorKey) {
    // 1. FOREGROUND MESSAGE - App open hai
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground FCM: ${message.data}");

      final data = message.data;
      final type = data['type']?.toString() ?? '';
      final showOverlay = data['show_overlay']?.toString() == 'true';

      // ✅ new_booking foreground mein bhi overlay dikhao
      if (_shouldShowOverlay(type, showOverlay)) {
        _triggerNativeOverlay(data);
        return; // notification show mat karo - overlay already dikhega
      }

      // Baaki notifications ke liye normal show
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        _localPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              icon: android?.smallIcon ?? '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
              playSound: false,
              enableVibration: false,
            ),
            iOS: const DarwinNotificationDetails(
              presentSound: false,
              presentAlert: true,
              presentBadge: true,
            ),
          ),
          payload: jsonEncode(data),
        );
      }
    });

    // 2. BACKGROUND TAP - notification tap kiya
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("App opened from notification: ${message.data}");
      // Yahan navigation add kar sakte ho agar chahiye
    });

    // 3. TERMINATED STATE - app band thi
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint("App launched from notification: ${message.data}");
      }
    });
  }

  // ✅ Helper: kaunse types pe overlay dikhana hai
  bool _shouldShowOverlay(String type, bool showOverlay) {
    const overlayTypes = {
      'incoming_order',
      'incoming_service_order',
      'new_service',
      'service_order',
      'service_booking',
    };

    if (overlayTypes.contains(type)) return true;

    // new_booking ke liye show_overlay true hona chahiye
    if (type == 'new_booking' || type == 'new_order') {
      return showOverlay;
    }

    return false;
  }

  // ✅ Native Android overlay trigger karo
  void _triggerNativeOverlay(Map<String, dynamic> data) {
    try {
      final String type = data['type']?.toString() ?? '';
      final bool isService =
          type == 'new_booking' ||
              type == 'incoming_service_order' ||
              type == 'new_service' ||
              type == 'service_order' ||
              type == 'service_booking';

      _nativeChannel.invokeMethod('scheduleIncomingOrderOverlay', {
        'pickup': data['pickup_address'] ?? data['address'] ?? '',
        'drop': data['drop_address'] ?? data['service_name'] ?? 'New Booking',
        'pickup_distance_km': data['pickup_distance_km'] ?? data['distance'] ?? '0.0',
        'distance_km': data['distance_km'] ?? '0.0',
        'amount': data['amount'] ?? data['service_price'] ?? data['total_amount'] ?? '0',
        'id': data['booking_id'] ?? data['ride_id'] ?? data['order_id'] ?? data['id'] ?? '',
        'user_id': data['user_id'] ?? '',
        'panel': isService ? 'serviceman' : 'driver',
        'order_type': int.tryParse(data['order_type']?.toString() ?? '1') ?? 1,
        'schedule_time': data['schedule_time'] ?? '',
        'delayMs': 0,
      });
      debugPrint("Native overlay triggered for type=$type");
    } catch (e) {
      debugPrint("Error triggering native overlay: $e");
    }
  }
}