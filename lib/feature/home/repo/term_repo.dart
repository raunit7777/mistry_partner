import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';

class TermRepository {
  final _apiServices = NetworkApiServices2();

  Future<dynamic> policiesApi(dynamic data) async {
    // 1. URL construct hone se pehle check karein
    final String requestUrl = AppUrl.policiesData + data.toString();
    if (kDebugMode) {
      print("📡 [TermRepository] Calling API URL: $requestUrl");
    }

    try {
      final response = await _apiServices.getGetApiResponse(requestUrl);

      // 2. Response check karein
      if (kDebugMode) {
        print("✅ [TermRepository] API Response: $response");
      }

      return response;
    } catch (e) {
      // 3. Error handling
      if (kDebugMode) {
        print("❌ [TermRepository] API ERROR: $e");
      }
      rethrow;
    }
  }
}