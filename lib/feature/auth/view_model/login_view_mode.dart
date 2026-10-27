// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../../confic/utils/routes/routes_name.dart';
// import '../../../confic/utils/toast.dart';
// import '../repo/send_otp_repo.dart';
//
// class LoginViewModel with ChangeNotifier {
//   final LoginRepository _loginRepo = LoginRepository();
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   String _fcmToken = "device_token";
//   String get fcmToken => _fcmToken;
//
//   void setFcmToken(String token) {
//     _fcmToken = token;
//     notifyListeners();
//   }
//
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   TextEditingController mobile = TextEditingController();
//
//   Future<void> login(BuildContext context, dynamic nav) async {
//     print("🚩${mobile.text} [1] Login process initiated.");
//
//     _setLoading(true);
//     print("🚩 [2] Loading state set to true.");
//
//     try {
//       final payload = {
//         "phone": mobile.text.trim(),
//       };
//       print("🚩 [3] Payload prepared: $payload");
//
//       final response = await _loginRepo.loginApi(payload);
//       print("🚩 [4] API Response received: $response");
//
//       final int statusCode = response?["statusCode"] ?? 0;
//       final String message = response?["data"]["message"] ?? "Something went wrong";
//
//       print("🚩 [5] Extracted StatusCode: $statusCode");
//       print("🚩 [6] Extracted Message: $message");
//
//       if (statusCode == 200) {
//         print("🚩 [7] Success! StatusCode is 200.");
//         if (context.mounted) {
//           Toast.show(context, message);
//
//           if (nav != 1) {
//             print("🚩 [8] Navigating to OTP Screen.");
//             Navigator.pushReplacementNamed(context, RoutesName.otpScreen);
//           } else {
//             print("🚩 [8] Navigation skipped (nav == 1).");
//           }
//         }
//       } else {
//         print("🚩 [7] Failure! StatusCode is not 200.");
//         if (context.mounted) {
//           Toast.show(context, message);
//         }
//       }
//     } catch (e) {
//       print("🚩 [ERROR] Catch block: $e");
//       if (context.mounted) {
//         Toast.show(context, "Error: $e", backgroundColor: Colors.red);
//       }
//     } finally {
//       print("🚩 [9] Finally block: Resetting loading state.");
//       _setLoading(false);
//     }
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../confic/utils/routes/routes_name.dart';
import '../../../confic/utils/toast.dart';
import '../repo/send_otp_repo.dart';

class LoginViewModel with ChangeNotifier {
  final LoginRepository _loginRepo = LoginRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _fcmToken = "device_token";
  String get fcmToken => _fcmToken;

  void setFcmToken(String token) {
    _fcmToken = token;
    print("🚩 [FCM] Token updated: $token");
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  TextEditingController mobile = TextEditingController();

  Future<void> login(BuildContext context, dynamic nav) async {
    print("🚩 [1] Login process started for: ${mobile.text.trim()}");

    _setLoading(true);
    print("🚩 [2] Loading state set to true.");

    try {
      final payload = {
        "phone": mobile.text.trim(),
      };
      print("🚩 [3] Payload prepared: $payload");

      final response = await _loginRepo.loginApi(payload);
      print("🚩 [4] API Response received: $response");

      final int statusCode = response?["statusCode"] ?? 0;
      final String message = response?["data"]["message"] ?? "Something went wrong";

      print("🚩 [5] Extracted Status Code: $statusCode");
      print("🚩 [6] Extracted Message: $message");

      if (statusCode == 200) {
        print("🚩 [7] Success! Status 200 received.");
        if (context.mounted) {
          Toast.show(context, message);

          if (nav != 1) {
            print("🚩 [8] Navigating to OTP Screen.");
            Navigator.pushReplacementNamed(context, RoutesName.otpScreen);
          } else {
            print("🚩 [8] Navigation skipped (nav == 1).");
          }
        }
      } else {
        print("🚩 [7] Failure! Status not 200. Message: $message");
        if (context.mounted) {
          Toast.show(context, message);
        }
      }
    } catch (e) {
      print("🚩 [ERROR] Catch block triggered: $e");
      if (context.mounted) {
        Toast.show(context, "Error: $e", backgroundColor: Colors.red);
      }
    } finally {
      print("🚩 [9] Finally block executed. Loading state set to false.");
      _setLoading(false);
    }
  }
}