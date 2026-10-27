
import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class OrderCompleteRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> orderCompletApi(dynamic data,dynamic id ) async {
    try {
      final response = await _apiServices.getPatchApiResponse(
        "${AppUrl.orderComplete}/$id/status",data

      );

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("orderCompletApi  Api API ERROR$e");
      }
      rethrow;
    }
  }
}
