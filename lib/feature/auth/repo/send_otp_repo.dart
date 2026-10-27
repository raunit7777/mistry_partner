import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class LoginRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      final response = await _apiServices.getPostApiResponse(
        AppUrl.login,data

      );
      // print("ram${response}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("loginOtpApi API ERROR$e");
      }
      rethrow;
    }
  }
}

