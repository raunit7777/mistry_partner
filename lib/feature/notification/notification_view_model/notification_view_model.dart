import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/notification/notification_repo/notification_repo.dart';

import '../model/notification_model.dart';





class NotificationViewModel with ChangeNotifier {
  final NotificationRepository _goalRepo = NotificationRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationModel? _serviceListData;
  NotificationModel? get serviceListData => _serviceListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> profileApi(BuildContext context) async {
    _setLoading(true);

    try {
      final response = await _goalRepo.notificationApi();

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

        _serviceListData = NotificationModel.fromJson(jsonBody);
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