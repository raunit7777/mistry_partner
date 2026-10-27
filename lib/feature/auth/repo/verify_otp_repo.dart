import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';


class VerifyOtpRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> verifyOtpApi(dynamic data) async {
    try {
      final response = await _apiServices.getPostApiResponse(
        AppUrl.otpVerify,
        data,
      );
      // print("ram${response}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("verifyOtpApi API ERROR$e");
      }
      rethrow;
    }
  }
}


