import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';

class ReadNotificationRepository {
  final _apiServices = NetworkApiServices2();

  Future<dynamic> readApi() async {
    try {

      final response = await _apiServices.getPatchApiResponse(
        AppUrl.readNotification,{}

      );

      if (kDebugMode) {
        print("✅ OnlineApi Response: $response");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("❌ onlineApi API ERROR: $e");
      }
      rethrow;
    }
  }
}