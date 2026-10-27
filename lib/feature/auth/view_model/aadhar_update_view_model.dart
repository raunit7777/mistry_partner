import 'package:flutter/material.dart';
import 'dart:io';
import '../../../confic/utils/routes/routes_name.dart';
import '../../../confic/utils/toast.dart';
import '../repo/aadhar_update_repo.dart'; // Apni repo ka sahi path dein

class AadharUpdateViewModel with ChangeNotifier {
  final AadharUpdateRepository _aadharRepo = AadharUpdateRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  String type = "1";
  Future<void> updateAadhar({
    required BuildContext context,
    required String aadharNumber,
    required File aadharFront,
    required File aadharBack,
  }) async {
    _setLoading(true);

    try {
      // API ke liye payload prepare karein
      final Map<String, dynamic> payload = {
        "aadhaar_number": aadharNumber,
        "aadhaar_front": aadharFront,
        "aadhaar_back": aadharBack,
      };

      final response = await _aadharRepo.aadharUpdateApi(payload);

      final int statusCode = response?["statusCode"] ?? 0;
      final String message = response?["msg"] ?? "Something went wrong";


      if (statusCode == 200 || statusCode == 201) {
        if (context.mounted) {
          Toast.show(context, message);

          if (type == "1") {
            Navigator.pushReplacementNamed(
              context,
              RoutesName.profileUpdateScreen,
              arguments: type,
            );
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