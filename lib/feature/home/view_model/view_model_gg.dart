import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import '../model/over_view_model.dart';

import '../repo/toady_over_view_repo.dart';







class ViewModelGg with ChangeNotifier {
  final ToadyOverViewRepository _goalRepo = ToadyOverViewRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OverVIewModel? _serviceListData;
  OverVIewModel? get serviceListData => _serviceListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> overViewApi(BuildContext context) async {
    _setLoading(true);
    print("🚩 [1] overViewApi triggered.");

    try {
      final response = await _goalRepo.todayOverApi();

      if (kDebugMode) print("🚩 [2] Raw Response received: $response");

      if (response != null) {
        Map<String, dynamic> jsonBody;

        // FIX: Agar statusCode 200 hai, toh pura 'data' map bhejo
        if (response.containsKey('statusCode')) {
          int code = int.parse(response['statusCode'].toString());
          if (code == 200) {
            // Hum sirf response['data'] bhej rahe hain kyunki model mein
            // 'status' aur 'data' (jisme stats hai) wahi se milenge
            jsonBody = response['data'] as Map<String, dynamic>;
          } else {
            print("⚠️ API Error Code: $code");
            _setLoading(false);
            return;
          }
        } else {
          jsonBody = response as Map<String, dynamic>;
        }

        print("🚩 [3] Parsed JSON Body for Model: $jsonBody");

        // 🔥 Model populate ho raha hai
        _serviceListData = OverVIewModel.fromJson(jsonBody);

        if (_serviceListData != null) {
          print("✅ [4] Success! Stats Earning: ${_serviceListData?.data?.stats?.totalEarning}");
        }
      }
    } catch (e, stack) {
      print("❌ [ERROR] API Error: $e");
      print("📍 StackTrace: $stack");
    } finally {
      _setLoading(false);
      notifyListeners();
      print("🚩 [6] Finally block. notifyListeners() called.");
    }
  }
}