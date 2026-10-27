// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:mishtry_partner/feature/auth/view_model/profile_view_model.dart';
// import 'package:provider/provider.dart';
// import '../../../confic/utils/toast.dart';
// import '../repo/online_repo.dart';
//
// class OnlineViewModel with ChangeNotifier {
//   final OnlineRepository _onlineRepo = OnlineRepository();
//
//   bool _isOnline = false;
//   bool get isOnline => _isOnline;
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   // Future<void> toggleOnlineStatus(BuildContext context) async {
//   //   if (kDebugMode) print("🚀 toggleOnlineStatus: Started. Current State: $_isOnline");
//   //
//   //   // Optimistic Update
//   //   bool previousStatus = _isOnline;
//   //   _isOnline = !_isOnline;
//   //   notifyListeners();
//   //
//   //   _setLoading(true);
//   //
//   //   try {
//   //     Position position = await _determinePosition();
//   //     String statusStr = _isOnline ? "online" : "offline";
//   //
//   //     // 1. API Payload Preparation
//   //     final payload = {
//   //       "status": statusStr,
//   //       "latitude": position.latitude,
//   //       "longitude": position.longitude,
//   //     };
//   //
//   //     // 2. API Call (Socket removed)
//   //     final response = await _onlineRepo.onlineApi(payload);
//   //
//   //     if (kDebugMode) print("✅ API Success: $response");
//   //
//   //     // Refresh profile data
//   //     if (context.mounted) {
//   //       Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
//   //       Toast.show(context, _isOnline ? "You are now Online" : "You are now Offline");
//   //     }
//   //   } catch (e) {
//   //     if (kDebugMode) print("❌ ERROR: $e");
//   //
//   //     // Revert logic on failure
//   //     _isOnline = previousStatus;
//   //     notifyListeners();
//   //
//   //     if (context.mounted) {
//   //       Toast.show(context, "Failed to update: ${e.toString()}", backgroundColor: Colors.red);
//   //     }
//   //   } finally {
//   //     _setLoading(false);
//   //   }
//   // }
//
//   Future<void> toggleOnlineStatus(BuildContext context) async {
//     bool previousStatus = _isOnline;
//     _isOnline = !_isOnline;
//     notifyListeners();
//
//     _setLoading(true);
//
//     try {
//       Position position = await _determinePosition();
//       String statusStr = _isOnline ? "online" : "offline";
//
//       final payload = {
//         "status": statusStr,
//         "latitude": position.latitude,
//         "longitude": position.longitude,
//       };
//
//       // Yahan API call karein
//       final response = await _onlineRepo.onlineApi(payload);
//
//       // --- Yahan Status Code aur Success Flag check karein ---
//       // Man lo response mein 'status' ya 'success' key hai
//       bool isSuccess = response['status'] == 'success' || response['code'] == 200;
//
//       if (isSuccess) {
//         if (kDebugMode) print("✅ API Success: $response");
//
//         if (context.mounted) {
//           Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
//           Toast.show(context, _isOnline ? "You are now Online" : "You are now Offline");
//         }
//       } else {
//         // Agar API ne error return kiya (jaise 400, 500, ya custom error)
//         throw Exception(response['message'] ?? "Something went wrong");
//       }
//
//     } catch (e) {
//       if (kDebugMode) print("❌ ERROR: $e");
//
//       // Revert logic
//       _isOnline = previousStatus;
//       notifyListeners();
//
//       if (context.mounted) {
//         Toast.show(context, "Failed: ${e.toString()}", backgroundColor: Colors.red);
//       }
//     } finally {
//       _setLoading(false);
//     }
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return Future.error('Location services are disabled.');
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
//     }
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mishtry_partner/feature/auth/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import '../../../confic/utils/toast.dart';
import '../repo/online_repo.dart';

class OnlineViewModel with ChangeNotifier {
  final OnlineRepository _onlineRepo = OnlineRepository();

  bool _isOnline = false;
  bool get isOnline => _isOnline;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> toggleOnlineStatus(BuildContext context) async {
    if (kDebugMode) print("🚀 toggleOnlineStatus: Started.");

    _setLoading(true);

    try {
      Position position = await _determinePosition();
      bool newStatus = !_isOnline;

      final payload = {
        "status": newStatus ? "online" : "offline",
        "latitude": position.latitude,
        "longitude": position.longitude,
      };

      // 1. API Call
      final response = await _onlineRepo.onlineApi(payload);

      // 2. Yahan se statusCode nikalo (jaisa aapke logs mein dikh raha hai)
      // Aapke log: {statusCode: 200, data: {...}}
      final int statusCode = response?['statusCode'] ?? 0;
      final String message = response?['data']?['message'] ?? "No message";

      if (kDebugMode) print("✅ Extracted Status: $statusCode");

      // 3. Logic check karo
      if (statusCode == 200) {
        _isOnline = newStatus; // ✅ Success hone par hi state change
        notifyListeners();

        if (context.mounted) {
          Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
          Toast.show(context, message);
        }
      } else {
        // Agar 200 nahi hai, toh toast dikhao
        if (context.mounted) {
          Toast.show(context, message, backgroundColor: Colors.red);
        }
      }
    } catch (e) {
      if (kDebugMode) print("❌ Exception: $e");
      if (context.mounted) {
        Toast.show(context, "Error: $e", backgroundColor: Colors.red);
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}