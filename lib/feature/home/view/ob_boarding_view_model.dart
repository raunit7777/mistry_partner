import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../auth/model/modelOnBoarding.dart';
import '../repo/on_boarding_repo.dart';

class ObBoardingViewModel with ChangeNotifier {
  final OnBoardingRepository _goalRepo = OnBoardingRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Model Getter
  OnBoardingStatusModel? _statusModel;
  OnBoardingStatusModel? get statusModel => _statusModel;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> oNBoardingApi() async {
    _setLoading(true);
    try {
      final response = await _goalRepo.onBoardingApi();

      if (response != null && response['statusCode'] == 200) {
        final Map<String, dynamic> jsonMap = response['data']['data'] ?? response['data'];

        // Data sirf model mein save hoga
        _statusModel = OnBoardingStatusModel.fromJson(jsonMap);
        notifyListeners();

        return true; // Success return kiya
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }
}