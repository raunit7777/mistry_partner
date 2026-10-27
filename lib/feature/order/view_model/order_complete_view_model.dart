import 'package:flutter/foundation.dart'; // kDebugMode ke liye
import 'package:flutter/material.dart';
import 'package:mishtry_partner/confic/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';
import '../../../confic/utils/toast.dart';
import '../repo/order_complete_repo.dart';

class OrderCompleteViewModel with ChangeNotifier {
  final OrderCompleteRepository _orderRepo = OrderCompleteRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> orderCompleteApi({
    required BuildContext context,
    required dynamic id,
    required Map<String, dynamic> data,
  }) async {
    _setLoading(true);

    if (kDebugMode) {
      print("🚀 OrderComplete API Start | ID: $id | Payload: $data");
    }

    try {
      final response = await _orderRepo.orderCompletApi(data, id);

      if (kDebugMode) {
        print("✅ OrderComplete API Response: $response");
      }

      final int statusCode = response?["statusCode"] ?? 0;
      final String message = response?["message"] ?? "Service completed successfully";

      if (statusCode == 200 || statusCode == 201) {
        if (context.mounted) {
          Toast.show(context, message);

          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          Toast.show(context, message, backgroundColor: Colors.red);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ OrderComplete API Error: $e");
      }
      if (context.mounted) {
        Toast.show(context, "Error: $e", backgroundColor: Colors.red);
      }
    } finally {
      _setLoading(false);
      if (kDebugMode) {
        print("🏁 OrderComplete API Finished");
      }
    }
  }
}