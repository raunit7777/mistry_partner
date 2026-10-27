// // import 'dart:async';
// // import 'package:flutter/material.dart';
// //
// // import 'login_screen.dart';
// //
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});
// //
// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen> {
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     Timer(const Duration(seconds: 3), () {
// //
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => const LoginScreen(),
// //         ),
// //       );
// //
// //     });
// //   }
// //   //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SizedBox(
// //         width: double.infinity,
// //         height: double.infinity,
// //         child: Image.asset(
// //           "assets/spl.png",
// //           fit: BoxFit.cover, // Pure screen cover karega
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // MethodChannel ke liye zaroori
// import 'login_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   // MethodChannel define karein [cite: 39]
//   static const channel = MethodChannel('rapido_background_button');
//
//   @override
//   void initState() {
//     super.initState();
//
//     // UI build hone ke baad permission check karein
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _maybeAskOverlayPermission();
//     });
//
//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const LoginScreen(),
//         ),
//       );
//     });
//   }
//
//   // Permission handling logic [cite: 48]
//   Future<void> _maybeAskOverlayPermission() async {
//     // 1. Native code se check karein [cite: 54]
//     final bool? hasPermission = await channel.invokeMethod<bool>('hasOverlayPermission');
//
//     if (hasPermission == true) return;
//
//     // 2. In-app dialog dikhayein [cite: 60]
//     final shouldOpenSettings = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('Allow overlay permission'),
//         content: const Text(
//           'To show the floating button when the app is in background, enable "Display over other apps".',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('Later'),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text('Allow'),
//           ),
//         ],
//       ),
//     );
//
//     // 3. Agar user ne Allow kiya toh settings open karein [cite: 84, 86]
//     if (shouldOpenSettings == true) {
//       try {
//         await channel.invokeMethod<void>('requestPermissions');
//       } catch (e) {
//         debugPrint("Error opening settings: $e");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: Image.asset(
//           "assets/spl.png",
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mishtry_partner/feature/auth/profile_wating_screen.dart';
import 'package:mishtry_partner/feature/auth/selct_services_screen.dart';
import 'package:mishtry_partner/feature/auth/select_city_screen.dart';
import 'package:mishtry_partner/feature/auth/upload_aadhar_screen.dart';
import 'package:mishtry_partner/feature/auth/view_model/profile_view_model.dart';
import 'package:mishtry_partner/feature/auth/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/view/bottom_nav.dart';
import '../home/view/ob_boarding_view_model.dart';
import '../home/view/update_profile_screen.dart';
import '../model/app_session_model.dart';
import '../model/user_session_model.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const channel = MethodChannel('rapido_background_button');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      await _loadSessionFromPrefs();


      _maybeAskOverlayPermission();

      await _checkUserAndNavigate();
    });
  }

  Future<void> _loadSessionFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    AppSession.session = UserSessionModel(
      userId: prefs.getString(PrefKeys.userId),
      token: prefs.getString(PrefKeys.token),
    );
  }

  Future<void> _checkUserAndNavigate() async {
    // 1. Session load karein (Agar zaroorat ho)
    await _loadSessionFromPrefs();

    final vm = Provider.of<ObBoardingViewModel>(context, listen: false);

    if (kDebugMode) print("📍 Logic: Checking onboarding status directly...");

    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;

      try {
        // 2. API call karein aur status model update karein
        // (Dhyaan dein: context pass karna zaroori hai agar ViewModel mein context use ho raha hai)
        bool success = await vm.oNBoardingApi();

        // 3. API success hone par condition check karein
        if (success && vm.statusModel != null && mounted) {
          final status = vm.statusModel!;

          if (status.allComplete && status.approvalStatus == 'approved') {
            _navigate(const NewBottomNav());
          }

          else if (!status.zoneStatus) {
            _navigate(const SelectCityScreen());
          }
          else if (!status.serviceStatus) {
            _navigate(const SelectServicesScreen());
          }
          else if (!status.aadhaarStatus) {
            _navigate(const AadharUploadScreen());
          }
          else if (!status.profileStatus) {
            _navigate(const ProfileUpdateScreen());
          }


          else if (status.approvalStatus == "pending") {
            _navigate(const ProfilePendingScreen());
          }
          else {
            // Fallback agar koi aur case ho
            _navigate(const LoginScreen());
          }
        } else {
          // Agar API fail ho jaye toh login par bhej dein
          _navigate(const LoginScreen());
        }
      } catch (e) {
        if (kDebugMode) print("❌ Error: $e");
        _navigate(const LoginScreen());
      }
    });
  }

// Helper method code clean rakhne ke liye
  void _navigate(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> _maybeAskOverlayPermission() async {
    final bool? hasPermission = await channel.invokeMethod<bool>('hasOverlayPermission');
    if (hasPermission == true) return;

    final shouldOpenSettings = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Allow overlay permission'),
        content: const Text('Enable "Display over other apps" for background services.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Later')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Allow')),
        ],
      ),
    );

    if (shouldOpenSettings == true) {
      await channel.invokeMethod<void>('requestPermissions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset("assets/spl.png", fit: BoxFit.cover),
      ),
    );
  }
}