// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
//
// import '../model/over_view_model.dart';
//
// import '../repo/toady_over_view_repo.dart';
//
//
//
//
//
//
//
// class TodayViewModel with ChangeNotifier {
//   final finalToadyOverViewRepository _goalRepo = ToadyOverViewRepository();
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   OverVIewModel? _serviceListData;
//   OverVIewModel? get serviceListData => _serviceListData;
//
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   Future<void> overViewApi(BuildContext context) async {
//     _setLoading(true);
//     print("🚩 [1] profileApi triggered.");
//
//     try {
//       final response = await _goalRepo.todayOverApi();
//
//       if (kDebugMode) print("🚩 [2] Raw Response received: $response");
//
//       if (response != null) {
//         Map<String, dynamic> jsonBody;
//
//         if (response.containsKey('statusCode')) {
//           jsonBody = (response['body'] ?? response['data'] ?? response) as Map<String, dynamic>;
//         } else {
//           jsonBody = response as Map<String, dynamic>;
//         }
//
//         print("🚩 [3] Parsed JSON Body for Model: $jsonBody");
//
//         // 🔥 Model mein data store karte waqt ka check
//         _serviceListData = OverVIewModel.fromJson(jsonBody);
//
//         if (_serviceListData != null) {
//           print("✅ [4] Success! Model successfully populated.");
//           // Yahan aap kuch specific field check kar sakte hain, jaise:
//           // print("🚩 [5] Model field check (e.g., name): ${_serviceListData?.data?.name}");
//         } else {
//           print("❌ [4] Error! Model is null after parsing.");
//         }
//       } else {
//         print("❌ [2] Response was null.");
//       }
//     } catch (e, stack) {
//       print("❌ [ERROR] service API Error: $e");
//       print("📍 StackTrace: $stack");
//     } finally {
//       _setLoading(false);
//       notifyListeners(); // 🔥 UI update karne ke liye notify zaroori hai
//       print("🚩 [6] Finally block. Loading set to false. notifyListeners() called.");
//     }
//   }
// }