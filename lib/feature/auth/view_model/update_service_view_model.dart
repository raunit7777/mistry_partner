import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/auth/repo/update_service_repo.dart';
import 'package:mishtry_partner/feature/auth/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import '../../../confic/utils/routes/routes_name.dart';
import '../../../confic/utils/toast.dart';
import '../upload_aadhar_screen.dart';



class UpdateServiceViewModel with ChangeNotifier {
  final UpdateServiceRepository _addressRepo = UpdateServiceRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

// UpdateServiceViewModel.dart mein update करें
  Future<void> updateServices({
    required BuildContext context,
    required List<int> serviceIds,
    required String nav,
    // String ki jagah List<int>
  }) async {
    _setLoading(true);

    try {
      final payload = {
        "service_ids": serviceIds // Backend ab array [1, 2] receive karega
      };

      final response = await _addressRepo.serviceUpdateApi(payload);

      final int statusCode = response?["statusCode"] ?? 0;
      final String message = response?["message"] ?? "Something went wrong";

      if (statusCode == 200 || statusCode == 201) {
        if (context.mounted) {
          Toast.show(context, message);
Provider.of<ProfileViewModel>(context,listen: false).profileApi(context);
          if (kDebugMode) {
            print("🎯 Navigation Logic Triggered | nav value: $nav");
          }

          if (nav == "1") {
            if (kDebugMode) print("🔙 Performing: Navigator.pop(context)");
            Navigator.pop(context);
          } else {
            if (kDebugMode) print("🚀 Performing: Navigator.pushReplacementNamed to selectServicesScreen");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AadharUploadScreen()));

          }

        }
      } else {
        if (context.mounted) {
          Toast.show(context, message, backgroundColor: Colors.red);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Toast.show(context, "Error: $e", backgroundColor: Colors.red);
      }
    } finally {
      _setLoading(false);
    }
  }
}