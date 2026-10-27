import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/auth/repo/profile_repo.dart';
import 'package:mishtry_partner/feature/payment/repo/get_bank_repo.dart';

import '../model/dash_bord_model.dart';
import '../repo/dash_bord_repo.dart';







class GetDashBord with ChangeNotifier {
  final DashBordRepository _goalRepo = DashBordRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DashbordModel? _serviceListData;
  DashbordModel? get serviceListData => _serviceListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> profileApi(BuildContext context) async {
    _setLoading(true);
    print("🚩 [1] profileApi triggered.");

    try {
      final response = await _goalRepo.dashBordApi();

      if (response != null) {
        Map<String, dynamic> jsonBody;

        // FIX: API response mein nested 'data' nahi hai.
        // API structure: {status: true, message: Success, data: {today: {...}}}
        // Hum direct 'response' (jo status, message, aur data hold karta hai) bhejenge.

        if (response.containsKey('statusCode')) {
          // response['body'] ya pura response object hi tumhare model ke format (status, data) ke hisaab se sahi hai
          jsonBody = (response['body'] ?? response) as Map<String, dynamic>;
        } else {
          jsonBody = response as Map<String, dynamic>;
        }

        print("🚩 [3] Parsed JSON Body for Model: $jsonBody");
        _serviceListData = DashbordModel.fromJson(jsonBody);

        if (_serviceListData?.data != null) {
          print("✅ [4] Success! Data populated.");
        } else {
          print("❌ [4] Error! 'data' key missing in JSON.");
        }
      }
    } catch (e, stack) {
      print("❌ [ERROR]: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
}