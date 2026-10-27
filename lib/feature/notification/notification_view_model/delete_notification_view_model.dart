import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/notification/notification_view_model/notification_view_model.dart';
import 'package:provider/provider.dart';
import '../../../confic/utils/toast.dart';
import '../notification_repo/delete_notification_repo.dart';

class DeleteNotificationViewModel with ChangeNotifier {
  final DeleteNotificationRepository _repo = DeleteNotificationRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> deleteNotificationApi(BuildContext context, String id) async {
    _setLoading(true); // Loading start

    try {
      // API call with ID
      final response = await _repo.deleteApi(id);

      if (kDebugMode) print("🗑️ Notification API Response: $response");

      // Response validation
      if (response != null && response is Map<String, dynamic>) {
        // Backend ke standard ke hisaab se check (statusCode 200 ya status true)
        if (response['statusCode'] == 200 || response['status'] == true) {

          if (context.mounted) {
            // Success hone par list refresh karein
            Provider.of<NotificationViewModel>(context, listen: false).profileApi(context);
            Toast.show(context, response['message'] ?? "Notification deleted successfully");
          }
        } else {
          // Failure handling
          if (context.mounted) {
            Toast.show(context, response['message'] ?? "Delete failed", backgroundColor: Colors.red);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print("❌ ERROR in deleteNotificationApi: $e");
      if (context.mounted) {
        Toast.show(context, "Error: ${e.toString()}", backgroundColor: Colors.red);
      }
    } finally {
      _setLoading(false); // Loading hamesha finally mein stop hogi
    }
  }
}