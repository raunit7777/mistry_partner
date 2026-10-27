import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class DashBordRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> dashBordApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        AppUrl.dashBord,

      );

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("dashBordApi API ERROR$e");
      }
      rethrow;
    }
  }
}


