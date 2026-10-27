import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class PoliciesRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> policiesApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        AppUrl.policies,

      );
      // print("ram${response}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("policiesApi API ERROR$e");
      }
      rethrow;
    }
  }
}


