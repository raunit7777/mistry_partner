// import 'package:flutter/material.dart';
//
// import 'feature/auth/spalsh_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
//
//
// double height = 0.0;
// double width = 0.0;
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//
//     height = MediaQuery.heightOf(context);
//     width = MediaQuery.widthOf(context);
//     return SafeArea(top: false,
//       child: MaterialApp(
//         title: 'Flutter Demo',debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//
//           colorScheme: .fromSeed(seedColor: Colors.deepPurple),
//         ),
//         home: SplashScreen(),
//       ),
//     );
//   }
// }
//


// import 'dart:async';
// import 'package:firebase_core/firebase_core.dart'; // Import Firebase
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mishtry_partner/res/const_color.dart';
// import 'package:provider/provider.dart';
// import 'confic/utils/routes/routes.dart';
// import 'confic/utils/routes/routes_name.dart';
// import 'feature/auth/view_model/aadhar_update_view_model.dart';
// import 'feature/auth/view_model/booking_view_model.dart';
// import 'feature/auth/view_model/login_view_mode.dart';
// import 'feature/auth/view_model/online_view_model.dart';
// import 'feature/auth/view_model/profile_view_model.dart';
// import 'feature/auth/view_model/select_zone_view_model.dart';
// import 'feature/auth/view_model/service_view_model.dart';
// import 'feature/auth/view_model/update_service_view_model.dart';
// import 'feature/auth/view_model/update_zone_view_model.dart';
// import 'feature/auth/view_model/user_view_model.dart';
// import 'feature/auth/view_model/verify_otp_view_model.dart';
// import 'feature/notification/notification_service.dart';
// import 'firebase_options.dart'; // Import generated options
// // ... baaki imports wahi rahengi
//
// double height = 0.0;
// double width = 0.0;
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   await NotificationService().initialize(navigatorKey);
//
//   // 🔥 Ye line check karein, iske bina token console par print nahi hoga
//   await NotificationService().getDeviceToken();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => UserViewModel()),
//         ChangeNotifierProvider(create: (_) => LoginViewModel()),
//         ChangeNotifierProvider(create: (_) => VerifyOtpViewModel()),
//         ChangeNotifierProvider(create: (_) => SelectZoneViewModel()),
//         ChangeNotifierProvider(create: (_) => ServiceViewModel()),
//         ChangeNotifierProvider(create: (_) => UpdateZoneViewModel()),
//         ChangeNotifierProvider(create: (_) => UpdateServiceViewModel()),
//         ChangeNotifierProvider(create: (_) => AadharUpdateViewModel()),
//         ChangeNotifierProvider(create: (_) => ProfileViewModel()),
//         ChangeNotifierProvider(create: (_) => OnlineViewModel()),
//         ChangeNotifierProvider(create: (_) => BookingViewModel()),
//       ],
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           height = constraints.maxHeight;
//           width = constraints.maxWidth;
//
//           return MaterialApp(
//             title: 'Mishtry',
//             navigatorKey: navigatorKey, // Navigator key yahan connected hai
//             debugShowCheckedModeBanner: false,
//
//             // Theme Setup
//             theme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(seedColor: ColorConst.orange),
//               useMaterial3: true,
//               appBarTheme: const AppBarTheme(
//                 scrolledUnderElevation: 0,
//                 elevation: 0,
//               ),
//             ),
//
//             // Glow effect hatane ke liye
//             scrollBehavior: NoGlowScrollBehavior(),
//
//             // Routing System
//             initialRoute: RoutesName.splash,
//             onGenerateRoute: (settings) {
//               if (settings.name != null) {
//                 return MaterialPageRoute(
//                   builder: Routers.generateRoute(settings.name!),
//                   settings: settings,
//                 );
//               }
//               return null;
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class NoGlowScrollBehavior extends ScrollBehavior {
//   @override
//   Widget buildOverscrollIndicator(
//       BuildContext context, Widget child, ScrollableDetails details) {
//     return child; // Modern flutter version mein buildOverscrollIndicator use hota hai
//   }
// }




// import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mishtry_partner/res/const_color.dart';
// import 'package:provider/provider.dart';
// import 'confic/utils/routes/routes.dart';
// import 'confic/utils/routes/routes_name.dart';
// import 'feature/auth/view_model/aadhar_update_view_model.dart';
// import 'feature/auth/view_model/booking_view_model.dart';
// import 'feature/auth/view_model/login_view_mode.dart';
// import 'feature/auth/view_model/online_view_model.dart';
// import 'feature/auth/view_model/profile_view_model.dart';
// import 'feature/auth/view_model/select_zone_view_model.dart';
// import 'feature/auth/view_model/service_view_model.dart';
// import 'feature/auth/view_model/update_service_view_model.dart';
// import 'feature/auth/view_model/update_zone_view_model.dart';
// import 'feature/auth/view_model/user_view_model.dart';
// import 'feature/auth/view_model/verify_otp_view_model.dart';
// import 'feature/notification/notification_service.dart';
// import 'firebase_options.dart';
//
// double height = 0.0;
// double width = 0.0;
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//
//   // Firebase Setup
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // Notification Service Setup
//   await NotificationService().initialize(navigatorKey);
//   await NotificationService().getDeviceToken();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   // Overlay Bubble ke liye MethodChannel [cite: 24]
//   static const channel = MethodChannel('rapido_background_button');
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this); // Lifecycle observe karne ke liye
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   // Lifecycle state change hone par bubble show/hide logic [cite: 97-100]
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.paused) {
//       channel.invokeMethod('showBackgroundButton'); // Background button show [cite: 99]
//     } else if (state == AppLifecycleState.resumed) {
//       channel.invokeMethod('hideBackgroundButton'); // Foreground button hide [cite: 100]
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => UserViewModel()),
//         ChangeNotifierProvider(create: (_) => LoginViewModel()),
//         ChangeNotifierProvider(create: (_) => VerifyOtpViewModel()),
//         ChangeNotifierProvider(create: (_) => SelectZoneViewModel()),
//         ChangeNotifierProvider(create: (_) => ServiceViewModel()),
//         ChangeNotifierProvider(create: (_) => UpdateZoneViewModel()),
//         ChangeNotifierProvider(create: (_) => UpdateServiceViewModel()),
//         ChangeNotifierProvider(create: (_) => AadharUpdateViewModel()),
//         ChangeNotifierProvider(create: (_) => ProfileViewModel()),
//         ChangeNotifierProvider(create: (_) => OnlineViewModel()),
//         ChangeNotifierProvider(create: (_) => BookingViewModel()),
//       ],
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           height = constraints.maxHeight;
//           width = constraints.maxWidth;
//
//           return MaterialApp(
//             title: 'Mishtry',
//             navigatorKey: navigatorKey,
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(seedColor: ColorConst.orange),
//               useMaterial3: true,
//             ),
//             scrollBehavior: NoGlowScrollBehavior(),
//             initialRoute: RoutesName.splash,
//             onGenerateRoute: (settings) => MaterialPageRoute(
//               builder: Routers.generateRoute(settings.name!),
//               settings: settings,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class NoGlowScrollBehavior extends ScrollBehavior {
//   @override
//   Widget buildOverscrollIndicator(context, child, details) => child;
// }

import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mishtry_partner/res/const_color.dart';
import 'package:provider/provider.dart';
import 'confic/utils/routes/routes.dart';
import 'confic/utils/routes/routes_name.dart';
import 'feature/auth/view_model/aadhar_update_view_model.dart';
import 'feature/auth/view_model/booking_view_model.dart';
import 'feature/auth/view_model/login_view_mode.dart';
import 'feature/auth/view_model/online_view_model.dart';
import 'feature/auth/view_model/profile_view_model.dart';
import 'feature/auth/view_model/select_zone_view_model.dart';
import 'feature/auth/view_model/service_view_model.dart';
import 'feature/auth/view_model/update_service_view_model.dart';
import 'feature/auth/view_model/update_zone_view_model.dart';
import 'feature/auth/view_model/user_view_model.dart';
import 'feature/auth/view_model/verify_otp_view_model.dart';
import 'feature/booking/view_model/booking_view_model.dart';

import 'feature/home/view/ob_boarding_view_model.dart';
import 'feature/home/view_model/Overview_view_model.dart';
import 'feature/home/view_model/get_dash_bord.dart';
import 'feature/home/view_model/pravcay_view_model.dart';
import 'feature/home/view_model/profile_update_view_model.dart';
import 'feature/home/view_model/view_model_gg.dart';
import 'feature/notification/notification_service.dart';
import 'feature/notification/notification_view_model/delete_notification_view_model.dart';
import 'feature/notification/notification_view_model/notification_read_view_model.dart';
import 'feature/notification/notification_view_model/notification_view_model.dart';
import 'feature/order/view_model/accept_view_model.dart';
import 'feature/order/view_model/addon_view_model.dart';
import 'feature/order/view_model/get_addon_view_model.dart';
import 'feature/order/view_model/order_complete_view_model.dart';
import 'feature/order/view_model/policies_view_model.dart';
import 'feature/order/view_model/term_view_model.dart';
import 'feature/payment/view_model/add_bank_view_model.dart';
import 'feature/payment/view_model/get_details_view_model.dart';
import 'feature/shocket/view_model/view_model_order.dart';
import 'firebase_options.dart';

double height = 0.0;
double width = 0.0;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Single instance - ek hi baar initialize karo
  final notifService = NotificationService();
  await notifService.initialize(navigatorKey);
  await notifService.getDeviceToken();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const _channel = MethodChannel('rapido_background_button');
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // ✅ FIX: onOverlayAcceptRide + onOverlayIgnoreRide bhi handle karo
    _channel.setMethodCallHandler((call) async {
      debugPrint('Native → Flutter: ${call.method} args=${call.arguments}');

      switch (call.method) {

        case 'navigateTo':
          final route = call.arguments as String?;
          if (route != null && route.isNotEmpty) {
            navigatorKey.currentState?.pushNamed(route);
          }
          break;

        case 'onOverlayAcceptRide':
        // Native overlay se accept kiya - booking_view_model ko notify karo
          final data = Map<String, dynamic>.from(call.arguments as Map);
          debugPrint('Overlay Accept: $data');
          _handleOverlayAccept(data);
          break;

        case 'onOverlayIgnoreRide':
          final data = Map<String, dynamic>.from(call.arguments as Map);
          debugPrint('Overlay Ignore: $data');
          _handleOverlayIgnore(data);
          break;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _tryHandleLaunchRoute());
  }

  // ✅ Accept handle - apne BookingViewModel ya route pe navigate karo
  void _handleOverlayAccept(Map<String, dynamic> data) async {
    final String orderId = data['id']?.toString() ?? '';

    if (orderId.isEmpty) return;

    try {
      final context = navigatorKey.currentContext;
      if (context != null) {

        // 1. Pehle Accept Order ki API chalao (ViewModel ke through)
        // Yahan 'ViewModelOrder' ka wo method use karein jo Accept API call karta hai
        // Agar aapke paas accept API method nahi hai, toh batayein main bana dunga
        await Provider.of<OrderAcceptViewModel>(context, listen: false).acceptOrder(orderId.toString());

        // 2. Phir jo pehle se chal raha tha (serviceApi) wo chalao
        // Ye list ko refresh kar dega
        await Provider.of<ViewModelOrder>(context, listen: false).serviceApi(context);

        debugPrint('✅ Order Accepted and Provider updated from Overlay Data');

        // Optional: Screen par notification dikhayein
        // Toast.show(context, "Order Accepted Successfully");
      }
    } catch (e) {
      debugPrint('Accept handle error: $e');
    }
  }

  // ✅ Ignore handle
  void _handleOverlayIgnore(Map<String, dynamic> data) {
    final String orderId = data['id']?.toString() ?? '';
    debugPrint('Order ignored: $orderId');
    // Kuch navigate nahi karna usually ignore pe
  }

  Future<void> _tryHandleLaunchRoute() async {
    try {
      final String? route = await _channel.invokeMethod<String>('getLaunchRoute');
      if (route != null && route.isNotEmpty) {
        navigatorKey.currentState?.pushNamed(route);
      }
    } catch (_) {}
  }

  void setOnlineState(bool online) {
    if (_isOnline == online) return;
    setState(() => _isOnline = online);

    try {
      _channel.invokeMethod<void>('setOnline', {'online': online});
      if (online) {
        _safeInvoke('showBackgroundButton');
      } else {
        _safeInvoke('hideBackgroundButton');
        _safeInvoke('cancelIncomingOrderOverlay');
        _safeInvoke('stopIncomingOrderAlert');
      }
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (_isOnline) _safeInvoke('showBackgroundButton');
    } else if (state == AppLifecycleState.resumed) {
      _safeInvoke('hideBackgroundButton');
      // ✅ Resume pe alert bhi stop karo - app foreground mein aa gayi
      _safeInvoke('stopIncomingOrderAlert');
    }
  }

  Future<void> _safeInvoke(String method, [Map<String, dynamic>? args]) async {
    try {
      await _channel.invokeMethod<void>(method, args);
    } catch (_) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => VerifyOtpViewModel()),
        ChangeNotifierProvider(create: (_) => SelectZoneViewModel()),
        ChangeNotifierProvider(create: (_) => ServiceViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateZoneViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateServiceViewModel()),
        ChangeNotifierProvider(create: (_) => AadharUpdateViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => OnlineViewModel()),
        ChangeNotifierProvider(create: (_) => BookingViewModel()),
        ChangeNotifierProvider(create: (_) => BookingViewModel2()),
        ChangeNotifierProvider(create: (_) => ViewModelOrder()),
        ChangeNotifierProvider(create: (_) => ProfileUpdateViewModel()),
        ChangeNotifierProvider(create: (_) => OrderAcceptViewModel()),
        ChangeNotifierProvider(create: (_) => OrderCompleteViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationReadViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => GetDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => AddBankViewModel()),
        ChangeNotifierProvider(create: (_) => AddonViewModel()),
        ChangeNotifierProvider(create: (_) => GetDashBord()),
        ChangeNotifierProvider(create: (_) => ViewModelGg()),
        ChangeNotifierProvider(create: (_) => GetAddonViewModel()),
        ChangeNotifierProvider(create: (_) => TermViewModel()),
        ChangeNotifierProvider(create: (_) => PravcayViewModel()),
        ChangeNotifierProvider(create: (_) => ObBoardingViewModel()),

      ],
      child: Consumer<OnlineViewModel>(
        builder: (context, onlineProvider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setOnlineState(onlineProvider.isOnline);
          });
          return child!;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            return MaterialApp(
              title: 'Mishtry',
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: ColorConst.orange),
                useMaterial3: true,
              ),
              initialRoute: RoutesName.splash,
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: Routers.generateRoute(settings.name!),
                settings: settings,
              ),
            );
          },
        ),
      ),
    );
  }
}