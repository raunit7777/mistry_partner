import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/get_addon_model.dart';
import '../repo/get_addon_repo.dart';







class GetAddonViewModel with ChangeNotifier {
  final GetAddonRepository _goalRepo = GetAddonRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GetAddOnVIewModel? _serviceListData;
  GetAddOnVIewModel? get serviceListData => _serviceListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> profileApi(BuildContext context,dynamic id) async {
    _setLoading(true);

    try {
      final response = await _goalRepo.getAddonApi(id);

      if (kDebugMode) print("📦 00000000Raw Response: $response");

      if (response != null) {


        Map<String, dynamic> jsonBody;

        if (response.containsKey('statusCode')) {

          jsonBody = (response['body'] ?? response['data'] ?? response)
          as Map<String, dynamic>;
        } else {

          jsonBody = response as Map<String, dynamic>;
        }

        if (kDebugMode) print("✅ Parsed JSON Body: $jsonBody");

        _serviceListData = GetAddOnVIewModel.fromJson(jsonBody);
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print("❌ service API Error: $e");
        print("📍 StackTrace: $stack");
      }
    } finally {
      _setLoading(false);
    }
  }
}