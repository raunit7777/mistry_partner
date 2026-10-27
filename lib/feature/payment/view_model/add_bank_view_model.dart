import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/auth/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import '../../../confic/utils/routes/routes_name.dart';
import '../../../confic/utils/toast.dart';
import '../repo/add_bank_detials_repo.dart';
import 'get_details_view_model.dart';

class AddBankViewModel with ChangeNotifier {
  final AddBankDetialsRepository _addressRepo = AddBankDetialsRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addBankDetails({
    required BuildContext context,
    required String bankName,
    required String holderName,
    required String accountNumber,
    required String ifscCode,
    required String nav,
  }) async {
    _setLoading(true);

    try {
      final payload = {
        "bank_name": bankName,
        "holder_name": holderName,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
      };

      final response = await _addressRepo.saveAddressApi(payload);

      final int statusCode = response?["statusCode"] ?? 0;
      final String message = response?["msg"] ?? "";

      if (statusCode == 200 || statusCode == 201) {
        if (context.mounted) {
          Toast.show(context, message);
          // Bank details update hone ke baad profile refresh karein
          Provider.of<GetDetailsViewModel>(context, listen: false).profileApi(context);

          // Navigation logic
          if (nav == "1") {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(context, RoutesName.selectServicesScreen);
          }
        }
      } else {
        if (context.mounted) {
          Toast.show(context, message, backgroundColor: Colors.red);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Toast.show(context, "Error: $e", backgroundColor: Colors.red);
      }
    } finally {
      _setLoading(false);
    }
  }
}