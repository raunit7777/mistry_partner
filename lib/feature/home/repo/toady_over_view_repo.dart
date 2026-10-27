import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class ToadyOverViewRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> todayOverApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        AppUrl.getDashBord,

      );
      // print("ram${response}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("todayOverApi API ERROR$e");
      }
      rethrow;
    }
  }
}


