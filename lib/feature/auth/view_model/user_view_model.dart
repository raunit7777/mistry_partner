import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefKeys {
  static const String userId = 'id';
  static const String status = 'status'; // ✅ FIX: Key hamesha String honi chahiye
  static const String token = 'token';
}

class UserViewModel extends ChangeNotifier {
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // ========== USER ID ==========
  Future<void> saveUser(String userId) async {
    try {
      final SharedPreferences prefs = await _getPrefs();
      await prefs.setString(PrefKeys.userId, userId);
      if (kDebugMode) {
        print("✅ user_id saved: $userId");
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error saving user_id: $e");
      }
    }
  }

  Future<String?> getUser() async {
    final SharedPreferences prefs = await _getPrefs();
    return prefs.getString(PrefKeys.userId);
  }

  // ========== STATUS ==========
  Future<void> saveStatus(String status) async {
    try {
      final SharedPreferences prefs = await _getPrefs();

      await prefs.setString(PrefKeys.status, status);
      if (kDebugMode) {
        print("✅ status saved: $status");
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error saving status: $e");
      }
    }
  }

  Future<String?> getStatus() async {
    final SharedPreferences prefs = await _getPrefs();
    final status = prefs.getString(PrefKeys.status);
    if (kDebugMode) {
      print("📦 Retrieved status: $status");
    }
    return status;
  }

  // ========== TOKEN ==========
  Future<void> saveToken(String token) async {
    try {
      final SharedPreferences prefs = await _getPrefs();
      await prefs.setString(PrefKeys.token, token);
      if (kDebugMode) {
        final preview = token.length > 20 ? token.substring(0, 20) : token;
        print("✅ token saved: $preview...");
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error saving token: $e");
      }
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await _getPrefs();
    return prefs.getString(PrefKeys.token);
  }

  // ========== REMOVE ALL DATA ==========
  Future<void> removeUser() async {
    try {
      final SharedPreferences prefs = await _getPrefs();
      // Saari keys ko remove karna
      await prefs.remove(PrefKeys.userId);
      await prefs.remove(PrefKeys.token);
      await prefs.remove(PrefKeys.status);

      if (kDebugMode) {
        print("✅ All user data cleared (ID, Token, Status)");
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error removing data: $e");
      }
    }
  }
}