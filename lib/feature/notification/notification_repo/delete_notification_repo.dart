import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';

class DeleteNotificationRepository {
  final _apiServices = NetworkApiServices2();

  // dynamic data ki jagah String id use karna zyada behtar hai
  Future<dynamic> deleteApi(String id) async {
    try {
      // URL ke sath ID attach karna
      // Note: Agar AppUrl.readNotification mein pehle se '/' nahi hai, toh '/$id' use karein
      final response = await _apiServices.getDeleteApiResponse(
        AppUrl.deleteNotification + id.toString(),
      );

      if (kDebugMode) {
        print("✅ DeleteNotification Response: $response");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("❌ DeleteNotification API ERROR: $e");
      }
      rethrow;
    }
  }
}