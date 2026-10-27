import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/auth/repo/profile_repo.dart';

import '../model/profile_model.dart';




class ProfileViewModel with ChangeNotifier {
  final ProfileRepository _goalRepo = ProfileRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProfileModel? _serviceListData;
  ProfileModel? get serviceListData => _serviceListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> profileApi(BuildContext context) async {
    _setLoading(true);

    try {
      final response = await _goalRepo.profileApi();

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

        _serviceListData = ProfileModel.fromJson(jsonBody);
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