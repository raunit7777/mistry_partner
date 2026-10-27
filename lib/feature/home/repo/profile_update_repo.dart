
import 'dart:io';

import '../../../confic/helper/network/network_api_services2.dart';

import '../../../res/aap_urls.dart';

class ProfileUpdateRepository {
  final _apiServices = NetworkApiServices2();

  // ProfileUpdateRepository mein change karein
  Future<dynamic> profileUpdateApi(String name, String email, File? image) async {
    try {
      String url = AppUrl.profileUpdate;

      // Yahan hum Map bana rahe hain jo NetworkApiServices2 ke formPutApiResponse ke liye zaruri hai
      final Map<String, dynamic> data = {
        "name": name,
        "email": email,
        if (image != null) "profile_image": image,
      };

      final response = await _apiServices.formPutApiResponse(url, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}