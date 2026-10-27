import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/notification/notification_repo/read_notification_repo.dart';
import 'package:mishtry_partner/feature/notification/notification_view_model/notification_view_model.dart';
import 'package:provider/provider.dart';
import '../../../confic/utils/toast.dart';

class NotificationReadViewModel with ChangeNotifier {
  final ReadNotificationRepository _onlineRepo = ReadNotificationRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> readStatus(BuildContext context) async {
    if (kDebugMode) print("🚀 readStatus: API Call Started");

    _setLoading(true);

    try {
      // API Call - No payload sent
      final response = await _onlineRepo.readApi();

      if (kDebugMode) print("@@@@@@ API Success: $response");

      // Refresh notification list after successful read action
      if (context.mounted) {
        Provider.of<NotificationViewModel>(context, listen: false).profileApi(context);
      }
    } catch (e) {
      if (kDebugMode) print("❌ ERROR in readStatus: $e");

      if (context.mounted) {
        Toast.show(context, "Failed to update: ${e.toString()}", backgroundColor: Colors.red);
      }
    } finally {
      _setLoading(false);
    }
  }
}