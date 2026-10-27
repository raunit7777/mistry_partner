import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class ProfileRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> profileApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        AppUrl.profile,

      );
      // print("ram${response}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("profileApi API ERROR$e");
      }
      rethrow;
    }
  }
}


