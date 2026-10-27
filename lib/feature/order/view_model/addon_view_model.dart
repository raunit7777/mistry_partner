import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../confic/utils/routes/routes_name.dart';
import '../../../confic/utils/toast.dart';
import '../../shocket/view_model/view_model_order.dart';
import '../repo/add_on_repo.dart';
import 'get_addon_view_model.dart';

class AddonViewModel with ChangeNotifier {
  final AddOnRepository _addonRepo = AddOnRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sendAddon(
      BuildContext context,
      dynamic id,
      List<Map<String, dynamic>> itemsList
      ) async {
    print("🚩 [1] sendAddon called. Service ID: $id");

    _setLoading(true);
    print("🚩 [2] Loading state set to true.");

    try {
      final payload = {
        "items": itemsList,
      };

      print("🚩 [3] Payload prepared: $payload");

      final response = await _addonRepo.addonApi(payload, id);
      print("🚩 [4] API Response received: $response");

      final int statusCode = response?["statusCode"] ?? 0;
      final String message = response?["msg"] ?? "Something went wrong";

      print("🚩 [5] Extracted Status Code: $statusCode");
      print("🚩 [6] Extracted Message: $message");

      if (statusCode == 200) {
        print("🚩 [7] Success! Status 200. Navigating back.");

        if (context.mounted) {
          Provider.of<GetAddonViewModel>(context, listen: false).profileApi(context,id);
          Provider.of<ViewModelOrder>(context, listen: false).serviceApi(context);
          Toast.show(context, message);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        print("🚩 [7] Failure! Status $statusCode. Message: $message");
        if (context.mounted) {
          Toast.show(context, message, backgroundColor: Colors.red);
        }
      }
    } catch (e) {
      print("🚩 [ERROR] Catch block triggered: $e");
      if (context.mounted) {
        Toast.show(context, "Error: $e", backgroundColor: Colors.red);
      }
    } finally {
      print("🚩 [8] Finally block. Loading state set to false.");
      _setLoading(false);
    }
  }
}