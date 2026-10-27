import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../home/repo/term_repo.dart';
import '../model/police_model.dart';
import '../model/term_model.dart';
import '../repo/police_repo.dart';

class TermViewModel with ChangeNotifier {
  final TermRepository _goalRepo = TermRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TermModel? _bannerListData;
  TermModel? get bannerListData => _bannerListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> bookingApi(BuildContext context, dynamic slug) async {
    _setLoading(true);
    try {
      final response = await _goalRepo.policiesApi(slug);

      if (response != null) {
        Map<String, dynamic> jsonBody;

        // Agar response mein statusCode 200 hai
        if (response.containsKey('statusCode')) {
          int code = int.parse(response['statusCode'].toString());
          if (code == 200) {
            // Pura response['data'] bhej rahe hain kyunki TermModel.fromJson handle kar lega
            jsonBody = response['data'] as Map<String, dynamic>;
          } else {
            return;
          }
        } else {
          jsonBody = response as Map<String, dynamic>;
        }

        _bannerListData = TermModel.fromJson(jsonBody);
        notifyListeners();
        if (kDebugMode) print("✅ Data Parsed: Title is ${_bannerListData?.data?.policy?.title}");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error: $e");
    } finally {
      _setLoading(false);
    }
  }
}