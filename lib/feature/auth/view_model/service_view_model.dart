import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/service_model.dart';

import '../repo/service_repo.dart';



class ServiceViewModel with ChangeNotifier {
  final ServiceRepository _goalRepo = ServiceRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ServiceModel? _serviceListData;
  ServiceModel? get serviceListData => _serviceListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> serviceApi(BuildContext context) async {
    _setLoading(true);

    try {
      final response = await _goalRepo.serviceApi();

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

        _serviceListData = ServiceModel.fromJson(jsonBody);
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