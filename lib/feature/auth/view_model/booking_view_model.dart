import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/booking_model.dart';
import '../model/service_model.dart';

import '../repo/booking_list_repo.dart';
import '../repo/service_repo.dart';



class BookingViewModel with ChangeNotifier {
  final BookingListRepository _goalRepo = BookingListRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BookingModel? _serviceListData;
  BookingModel? get serviceListData => _serviceListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> serviceApi(BuildContext context) async {
    _setLoading(true);
    if (kDebugMode) print("🚀 Starting serviceApi call...");

    try {
      final response = await _goalRepo.bookingApi();

      if (kDebugMode) print("📦 Raw Response Received: $response");

      if (response != null) {
        Map<String, dynamic> jsonBody;

        if (response.containsKey('statusCode')) {
          // Aapke latest log ke hisaab se path adjust kiya hai
          jsonBody = (response['data'] ?? response['body'] ?? response) as Map<String, dynamic>;
          if (kDebugMode) print("🔍 Extracted body from status code response");
        } else {
          jsonBody = response as Map<String, dynamic>;
          if (kDebugMode) print("🔍 Using response as direct map");
        }

        if (kDebugMode) print("✅ Parsed JSON Body: $jsonBody");

        // ── MODEL SETTING LOGS ──
        _serviceListData = BookingModel.fromJson(jsonBody);

        if (_serviceListData != null) {
          if (kDebugMode) {
            print("🎉 BookingModel successfully initialized!");
            print("📊 Data object: ${_serviceListData!.data}");

            if (_serviceListData!.data != null && _serviceListData!.data!.bookings != null) {
              print("📜 Bookings found: ${_serviceListData!.data!.bookings!.length}");
            } else {
              print("⚠️ Data or Bookings list inside model is NULL");
            }
          }
        } else {
          if (kDebugMode) print("❌ FAILED to initialize BookingModel (returned null)");
        }

      } else {
        if (kDebugMode) print("❌ API Response is NULL");
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print("❌ CRITICAL ERROR in serviceApi: $e");
        print("📍 StackTrace: $stack");
      }
    } finally {
      _setLoading(false);
      if (kDebugMode) print("🏁 API Request finished, loading set to false.");
      notifyListeners();
    }
  }
}