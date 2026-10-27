// import 'package:flutter/material.dart';
// import '../model/booking_model.dart';
//
// class BookingViewModel2 extends ChangeNotifier {
//   BookingModel2? _latestBooking;
//   BookingModel2? get latestBooking => _latestBooking;
//
//   void setNewBooking(Map<String, dynamic> data) {
//
//     debugPrint("📥 Received Booking Data: $data");
//
//     _latestBooking = BookingModel2.fromJson(data);
//
//     // Model set hone ke baad print
//     debugPrint("✅ Model Set Successfully: ${_latestBooking!.serviceName}, ID: ${_latestBooking!.bookingId}");
//
//     notifyListeners();
//   }
//
//   void clearBooking() {
//     debugPrint("🧹 Clearing Booking Data");
//     _latestBooking = null;
//     notifyListeners();
//   }
// }

import 'dart:convert'; // Import this
import 'package:flutter/material.dart';
import '../model/booking_model.dart';

class BookingViewModel2 extends ChangeNotifier {
  BookingModel2? _latestBooking;
  BookingModel2? get latestBooking => _latestBooking;

  void setNewBooking(Map<String, dynamic> data) {
    // Pretty Print JSON (Structure format mein dikhega)
    const encoder = JsonEncoder.withIndent('  ');
    String prettyJson = encoder.convert(data);

    debugPrint("🔔 --- FULL INCOMING JSON DATA --- 🔔");
    debugPrint(prettyJson);
    debugPrint("🔔 --------------------------------- 🔔");

    try {
      _latestBooking = BookingModel2.fromJson(data);
      debugPrint("✅ Model Successfully Parsed: ${_latestBooking!.serviceName}");
    } catch (e) {
      debugPrint("❌ Error parsing model: $e");
    }

    notifyListeners();
  }

  void clearBooking() {
    _latestBooking = null;
    notifyListeners();
  }
}