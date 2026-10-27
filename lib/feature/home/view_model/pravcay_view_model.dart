import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../order/model/police_model.dart';
import '../../order/model/policy_model.dart';
import '../../order/repo/police_repo.dart';
import '../../order/repo/polycies_repo.dart';





class PravcayViewModel with ChangeNotifier {
  final PoliciesRepository _goalRepo = PoliciesRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PolicesModel? _bannerListData;
  PolicesModel? get bannerListData => _bannerListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> bookingApi(BuildContext context) async {
    _setLoading(true);

    try {
      final response = await _goalRepo.policiesApi();

      if (kDebugMode) print("222222📦 Raw Response: $response");

      if (response != null) {
        Map<String, dynamic> jsonBody;

        if (response.containsKey('statusCode')) {
          jsonBody = (response['body'] ?? response['data'] ?? response)
          as Map<String, dynamic>;
        } else {
          jsonBody = response as Map<String, dynamic>;
        }

        if (kDebugMode) print("✅ Parsed JSON Body: $jsonBody");

        // 1. Model me data parse ho rha hai
        _bannerListData = PolicesModel.fromJson(jsonBody);

        // 2. 🟢 DATA STORE HUA YA NHI YAHAN CHECK KAREIN
        if (kDebugMode) {
          print("--------------------------------------------------");
          print("🔮 Model Storage Check:");
          print("Instance created: ${_bannerListData != null}");

          if (_bannerListData != null) {
            // Note: 'status' aur 'data' ki jagah apne PolicesModel ke actual fields ke naam likhein
            print("Model Status Field: ${_bannerListData?.status}");

            // Agar aapke model me list hai (e.g., 'data' ya 'bookings') to uski length check karein:
            // print("Data List Length: ${_bannerListData?.data?.length}");
          }
          print("--------------------------------------------------");
        }
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print("❌ Banner API Error: $e");
        print("📍 StackTrace: $stack");
      }
    } finally {
      _setLoading(false);
    }
  }
}