import 'package:flutter/foundation.dart';

import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
import '../../../feature/model/app_session_model.dart';

class AadharUpdateRepository {
  final _apiServices = NetworkApiServices2();

  Future<dynamic> aadharUpdateApi(Map<String, dynamic> data) async {
    try {

      final headers = {
        'Authorization': 'Bearer ${AppSession.session?.token ?? ''}',
      };

      if (kDebugMode) {
        print("🌍 UpdateService URL: ${AppUrl.workerAadhar}");
        print("📦 UpdateService Data: $data");
      }

      final response = await _apiServices.formPostApiResponse(
        AppUrl.workerAadhar,
        data,
        headers: headers,
      );

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("serviceUpdateApi ERROR: $e");
      }
      rethrow;
    }
  }
}