import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/auth/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import '../../../confic/utils/routes/routes_name.dart';
import '../../../confic/utils/toast.dart';
import '../repo/update_zone_repo.dart';


class UpdateZoneViewModel with ChangeNotifier {
  final UpdateZoneRepository _addressRepo = UpdateZoneRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> selectZone({
    required BuildContext context,
    required String zoneId, // addressId ki jagah zoneId use karein
    required String nav, // addressId ki jagah zoneId use karein
  }) async {
    _setLoading(true);

    try {
      // Payload define karein
      final payload = {
        "zone_id": zoneId
      };

      // Payload pass karein (Make sure aapke Repo mein payload accept ho raha ho)
      final response = await _addressRepo.saveAddressApi(payload);

      final int statusCode = response?["statusCode"] ?? 0;
      final String message = response?["data"]?["message"] ??
          response?["message"] ??
          "Something went wrong";

      if (statusCode == 200 || statusCode == 201) {
        if (context.mounted) {
          Toast.show(context, message);
          Provider.of<ProfileViewModel>(context,listen: false).profileApi(context);
          // Debug print
          if (kDebugMode) {
            print("🎯 Navigation Logic Triggered | nav value: $nav");
          }

          if (nav == "1") {
            if (kDebugMode) print("🔙 Performing: Navigator.pop(context)");
            Navigator.pop(context);
          } else {
            if (kDebugMode) print("🚀 Performing: Navigator.pushReplacementNamed to selectServicesScreen");
            Navigator.pushReplacementNamed(context, RoutesName.selectServicesScreen);
          }
        }
      } else {
        if (kDebugMode) {
          print("⚠️ API Success but logic error (Status Code: $statusCode)");
        }
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