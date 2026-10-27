import 'package:flutter/material.dart';
import '../../../feature/auth/login_screen.dart';
import '../../../feature/auth/otp_screen.dart';
import '../../../feature/auth/profile_wating_screen.dart';
import '../../../feature/auth/selct_services_screen.dart';
import '../../../feature/auth/select_city_screen.dart';
import '../../../feature/auth/select_zone_screen.dart';
import '../../../feature/auth/spalsh_screen.dart';
import '../../../feature/auth/upload_aadhar_screen.dart';
import '../../../feature/home/view/bottom_nav.dart';

import '../../../feature/home/view/today_over_view_screen.dart';
import '../../../feature/home/view/update_profile_screen.dart';
import '../../../feature/order/view/add_on_screen.dart';
import '../../../feature/payment/view/add_bank_details_screen.dart';
import '../../../feature/term_and_condition/view/term_and_condition.dart';
import 'routes_name.dart';

class Routers {
  static WidgetBuilder generateRoute(String routeName) {
    switch (routeName) {
      case RoutesName.splash:
        return (context) => const SplashScreen();

    //   case RoutesName.splash:
    //     return (context) => const BottomNav();
    case RoutesName.otpScreen:
    return (context) => const OtpVerificationScreen();
    //
    //   case RoutesName.bottomNavDemo:
    //     return (context) => const BottomNav();
      case RoutesName.loginScreen:
        return (context) => const LoginScreen();
      case RoutesName.selectZoneScreen:
        return (context) => const SelectCityScreen();
      case RoutesName.bottomNavDemo:
        return (context) => const NewBottomNav();

      case RoutesName.selectServicesScreen:
        return (context) => const SelectServicesScreen();

      case RoutesName.aadharUploadScreen:
        return (context) => const AadharUploadScreen();
      case RoutesName.profilePendingScreen:
        return (context) => const ProfilePendingScreen();
    case RoutesName.profileUpdateScreen:
    return (context) => const ProfileUpdateScreen();

    case RoutesName.termsAndConditionsScreen:
    return (context) => const TermsAndConditionsScreen();

    case RoutesName.bankDetailsScreen:
    return (context) => const BankDetailsScreen();
    case RoutesName.manualAddonScreen:
    return (context) => const ManualAddonScreen(serviceId: '',);
    case RoutesName.todayOverviewScreen:
    return (context) => const TodayOverviewScreen();
    default:
        return (context) => const Scaffold(
          body: Center(
            child: Text(
              'No Route Found!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        );
    }
  }
}