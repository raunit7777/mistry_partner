

import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class ServiceRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> serviceApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        AppUrl.service,

      );
      // print("ram${response}");dw
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("service  Api API ERROR$e");
      }
      rethrow;
    }
  }
}


