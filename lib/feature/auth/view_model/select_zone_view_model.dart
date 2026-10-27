import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/zone_model.dart';
import '../repo/select_zone_repo.dart';



class SelectZoneViewModel with ChangeNotifier {
  final ZoneRepository _goalRepo = ZoneRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ZoneResponse? _bannerListData;
  ZoneResponse? get bannerListData => _bannerListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> bannerApi(BuildContext context) async {
    _setLoading(true);

    try {
      final response = await _goalRepo.bannerApi();

      if (kDebugMode) print("📦 Raw Response: $response");

      if (response != null) {


        Map<String, dynamic> jsonBody;

        if (response.containsKey('statusCode')) {

          jsonBody = (response['body'] ?? response['data'] ?? response)
          as Map<String, dynamic>;
        } else {

          jsonBody = response as Map<String, dynamic>;
        }

        if (kDebugMode) print("✅ Parsed JSON Body: $jsonBody");

        _bannerListData = ZoneResponse.fromJson(jsonBody);
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