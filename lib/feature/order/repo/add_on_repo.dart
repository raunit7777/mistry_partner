import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';

class AddOnRepository {
  final _apiServices = NetworkApiServices2();

  // 'dyanmic' ki spelling sahi ki, ID aur data pass kiya
  Future<dynamic> addonApi(dynamic data, dynamic id) async {
    try {
      // URL format: AppUrl.login + id + "/addons"
      final String url = "${AppUrl.addOn}$id/addons";

      final response = await _apiServices.getPostApiResponse(url, data);

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("❌ addonApi API ERROR: $e");
      }
      rethrow;
    }
  }
}