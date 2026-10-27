import 'package:mishtry_partner/feature/model/user_session_model.dart';

class AppSession {
  static UserSessionModel? session;

  static bool get isLoggedIn =>
      session != null &&
          session!.token != null &&
          session!.token!.isNotEmpty;

  static void clear() {
    session = null;
  }
}
