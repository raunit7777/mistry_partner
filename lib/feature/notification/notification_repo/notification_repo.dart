import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class NotificationRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> notificationApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        AppUrl.notificationList,

      );
      // print("ram${response}");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("notificationApi API ERROR$e");
      }
      rethrow;
    }
  }
}


