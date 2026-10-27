import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/auth/repo/profile_repo.dart';
import 'package:mishtry_partner/feature/payment/repo/get_bank_repo.dart';

import '../model/bank_model.dart';





class GetDetailsViewModel with ChangeNotifier {
  final GetBankRepository _goalRepo = GetBankRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BankModel? _serviceListData;
  BankModel? get serviceListData => _serviceListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> profileApi(BuildContext context) async {
    _setLoading(true);

    try {
      final response = await _goalRepo.bankApi();

      if (kDebugMode) print("📦 Raw Response: $response");

      if (response != null) {


        Map<String, dynamic> jsonBody;

        if (response.containsKey('statusCode')) {

          jsonBody = (response['body'] ?? response['data'] ?? response)
          as Map<String, dynamic>;
        } else {

          jsonBody = response as Map<String, dynamic>;
        }

        if (kDebugMode) print("✅ Parsed JSON Body: $jsonBody");

        _serviceListData = BankModel.fromJson(jsonBody);
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print("❌ service API Error: $e");
        print("📍 StackTrace: $stack");
      }
    } finally {
      _setLoading(false);
    }
  }
}