

import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/auth/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../confic/utils/routes/routes_name.dart';
import '../../../confic/utils/toast.dart';
import '../../home/view/ob_boarding_view_model.dart';
import '../../model/app_session_model.dart';
import '../../model/user_session_model.dart';
import '../../notification/notification_service.dart';
import '../repo/verify_otp_repo.dart';
import 'login_view_mode.dart';

class VerifyOtpViewModel with ChangeNotifier {
  final VerifyOtpRepository _loginRepo = VerifyOtpRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  TextEditingController otp = TextEditingController();
  Future<void> _loadSessionFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    AppSession.session = UserSessionModel(
      userId: prefs.getString(PrefKeys.userId),
      token: prefs.getString(PrefKeys.token),
    );
  }
  Future<void> verifyOtp(BuildContext context) async {
    print("🚀 verifyOtp Started");

    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final userVM = Provider.of<UserViewModel>(context, listen: false);
    final obBoardingVM = Provider.of<ObBoardingViewModel>(context, listen: false);

    print("📱 Mobile: ${loginVM.mobile.text.trim()}");
    print("🔢 OTP: ${otp.text.trim()}");

    String? fcmToken = await NotificationService().getDeviceToken();
    print("📲 FCM Token: $fcmToken");

    _setLoading(true);
    print("⏳ Loading Started");

    try {
      print("📡 Calling verifyOtpApi...");

      final response = await _loginRepo.verifyOtpApi({
        "phone": loginVM.mobile.text.trim(),
        "otp": otp.text.trim(),
        "fcm_token": fcmToken,
      });

      print("✅ API Response Received");
      print("🔍 Full Response: $response");
      print("🔍 Response Type: ${response.runtimeType}");
      print("🔍 Response keys: ${response?.keys}");

      if (response == null) {
        print("❌ Response is NULL");
        if (context.mounted) {
          Toast.show(context, "No response from server", backgroundColor: Colors.red);
        }
        return;
      }

      final int? statusCode = response["statusCode"];
      final bool? statusBool = response["status"];

      print("📌 statusCode: $statusCode");
      print("📌 statusBool: $statusBool");

      final bool isSuccess = (statusCode == 200) || (statusBool == true);

      print("📌 isSuccess: $isSuccess");

      if (!isSuccess) {
        print("❌ API Failed");
        print("❌ Message: ${response["message"]}");
        if (context.mounted) {
          Toast.show(context, response["message"] ?? "Login failed", backgroundColor: Colors.red);
        }
        return;
      }

      Map<String, dynamic>? innerData;
      String? token;

      final dynamic topLevel = response["data"];

      print("📦 topLevel: $topLevel");
      print("📦 topLevel Type: ${topLevel.runtimeType}");

      if (topLevel is Map<String, dynamic>) {
        print("✅ topLevel is Map");

        if (topLevel.containsKey("data") && topLevel["data"] is Map<String, dynamic>) {
          print("📂 Case 1: Nested data found");
          innerData = topLevel["data"] as Map<String, dynamic>;
          token = innerData["token"]?.toString();
        } else if (topLevel.containsKey("token")) {
          print("📂 Case 2: Direct token found");
          innerData = topLevel;
          token = innerData["token"]?.toString();
        }
      }

      print("📌 innerData: $innerData");
      print("🔑 Token: $token");

      if (innerData == null) {
        print("❌ innerData is NULL");
        if (context.mounted) {
          Toast.show(context, "Invalid response format", backgroundColor: Colors.red);
        }
        return;
      }

      final dynamic rawWorker = innerData["worker"];

      print("👷 rawWorker: $rawWorker");
      print("👷 rawWorker Type: ${rawWorker.runtimeType}");

      if (rawWorker is! Map<String, dynamic>) {
        print("❌ Worker data missing or invalid");
        if (context.mounted) {
          Toast.show(context, "Worker data missing", backgroundColor: Colors.red);
        }
        return;
      }

      final Map<String, dynamic> workerData = rawWorker;
      print("👷 Worker Data: $workerData");

      // 1. Token Save
      if (token != null) {
        print("💾 Saving Token...");
        await userVM.saveToken(token);
        print("✅ Token Saved");
      }

      // 2. Worker ID Save
      final String? workerId = workerData["id"]?.toString();
      print("🆔 Worker ID: $workerId");
      if (workerId != null) {
        print("💾 Saving Worker ID...");
        await userVM.saveUser(workerId);
        print("✅ Worker ID Saved");
      }

      final bool isNew = workerData["is_new"] == true;
      print("🆕 Is New User: $isNew");

      if (!context.mounted) {
        print("❌ Context not mounted");
        return;
      }

      Toast.show(context, response["message"] ?? innerData["message"] ?? "Login successful");

      // ✅ Dono cases (new + existing) ke liye onboarding status check
      print("📡 Calling oNBoardingApi...");
      await _loadSessionFromPrefs();
      await Future.delayed(const Duration(seconds: 1));

      bool success = await obBoardingVM.oNBoardingApi();
      print("📌 Onboarding API Success: $success");

      final status = obBoardingVM.statusModel;
      print("📊 Status Model: $status");

      if (!context.mounted) return;

      if (success && status != null) {
        print("📌 allComplete: ${status.allComplete}");
        print("📌 approvalStatus: ${status.approvalStatus}");
        print("📌 profileStatus: ${status.profileStatus}");
        print("📌 zoneStatus: ${status.zoneStatus}");
        print("📌 serviceStatus: ${status.serviceStatus}");
        print("📌 aadhaarStatus: ${status.aadhaarStatus}");
        print("📌 bankStatus: ${status.bankStatus}");

        if (status.allComplete && status.approvalStatus == 'approved') {
          print("🏠 Navigate -> bottomNavDemo");
          Navigator.pushNamedAndRemoveUntil(context, RoutesName.bottomNavDemo, (route) => false);



        } else if (!status.zoneStatus) {
          print("📍 Navigate -> selectZoneScreen");
          Navigator.pushNamed(context, RoutesName.selectZoneScreen);

        } else if (!status.serviceStatus) {
          print("🛠 Navigate -> selectServicesScreen");
          Navigator.pushNamed(context, RoutesName.selectServicesScreen);

        } else if (!status.aadhaarStatus) {
          print("🪪 Navigate -> aadharUploadScreen");
          Navigator.pushNamed(context, RoutesName.aadharUploadScreen);



        } else if (status.approvalStatus == "pending") {
          print("⏳ Navigate -> profilePendingScreen");
          Navigator.pushNamed(context, RoutesName.profilePendingScreen);

        } else {
          print("🔐 Navigate -> loginScreen");
          Navigator.pushNamedAndRemoveUntil(context, RoutesName.loginScreen, (route) => false);
        }
      } else {
        // Onboarding API fail ho jaye to bhi safe fallback
        print("⚠️ Onboarding failed - Navigate -> bottomNavDemo");
        Navigator.pushReplacementNamed(context, RoutesName.bottomNavDemo);
      }

    } catch (e, stackTrace) {
      print("❌ Critical Error: $e");
      print("📍 StackTrace:");
      print(stackTrace);
      if (context.mounted) {
        Toast.show(context, "Something went wrong", backgroundColor: Colors.red);
      }
    } finally {
      print("🏁 verifyOtp Finished");
      _setLoading(false);
      print("⏳ Loading Stopped");
    }
  }


}