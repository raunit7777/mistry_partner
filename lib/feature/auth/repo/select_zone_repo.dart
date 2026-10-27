import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class ZoneRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> bannerApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        AppUrl.zone,

      );
      // print("ram${response}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("bannerApi API ERROR$e");
      }
      rethrow;
    }
  }
}


