// import 'package:flutter/foundation.dart';
// import '../../../confic/helper/network/network_api_services2.dart';
// import '../../../res/aap_urls.dart';
//
// class UpdateZoneRepository {
//   final _apiServices = NetworkApiServices2();
//
//   Future<dynamic> saveAddressApi(dynamic addressId) async {
//     try {
//       final response = await _apiServices.getPutApiResponse(
//         "ramu${AppUrl.zone}",addressId
//
//       );
//
//       return response;
//     } catch (e) {
//       if (kDebugMode) {
//         print("saveAddressApi API ERROR: $e");
//       }
//       rethrow;
//     }
//   }
// }
// UpdateZoneRepository.dart mein ye change karein:

import 'package:flutter/foundation.dart';

import '../../../confic/helper/network/network_api_services2.dart';
import '../../../res/aap_urls.dart';

class UpdateZoneRepository {
  final _apiServices = NetworkApiServices2();

  Future<dynamic> saveAddressApi(dynamic data) async {
    try {
      String url = AppUrl.selectzone;

      if (kDebugMode) {
        print("🌍 UpdateZone API URL: $url");
        print("📦 UpdateZone Payload: $data");
      }

      final response = await _apiServices.getPutApiResponse(
          url,
          data
      );

      if (kDebugMode) {
        print("✅ UpdateZone API Response: $response");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("❌ saveAddressApi API ERROR: $e");
      }
      rethrow;
    }
  }
}