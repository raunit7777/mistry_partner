
import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class OrderRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> orderApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        AppUrl.booking2,

      );

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("orderApi  Api API ERROR$e");
      }
      rethrow;
    }
  }
}
