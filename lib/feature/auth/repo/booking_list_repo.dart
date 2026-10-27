import 'package:flutter/foundation.dart';
import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';
class BookingListRepository {

  final _apiServices = NetworkApiServices2();

  Future<dynamic> bookingApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        AppUrl.booking,

      );

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("bookingApi  Api API ERROR$e");
      }
      rethrow;
    }
  }
}
