// import 'dart:io';
// import 'package:flutter/material.dart';
//
// import '../../../confic/utils/toast.dart';
// import '../repo/profile_update_repo.dart';
//
// class ProfileUpdateViewModel with ChangeNotifier {
//   final ProfileUpdateRepository _profileRepo = ProfileUpdateRepository();
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   Future<void> profileUpdate({
//     required BuildContext context,
//     required String name,
//     required String email,
//     File? image,
//   }) async {
//     _setLoading(true);
//
//     try {
//       // API Payload - Agar image upload ho rahi hai toh Repository mein Multipart use karein
//       final Map<String, dynamic> payload = {
//         "name": name,
//         "email": email,
//         if (image != null) "profile_image": image,
//       };
//
//       final response = await _profileRepo.profileUpdateApi(payload);
//
//       final int statusCode = response?["statusCode"] ?? 0;
//       final String message = response?["message"] ?? "Updated successfully";
//
//       if (statusCode == 200 || statusCode == 201) {
//         if (context.mounted) {
//           Toast.show(context, message);
//
//           Navigator.pop(context);
//         }
//       } else {
//         if (context.mounted) {
//           Toast.show(context, message, backgroundColor: Colors.red);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         Toast.show(context, "Error: $e", backgroundColor: Colors.red);
//       }
//     } finally {
//       _setLoading(false);
//     }
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/confic/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';
import '../../../confic/utils/toast.dart';
import '../../auth/view_model/profile_view_model.dart';
import '../repo/profile_update_repo.dart';

class ProfileUpdateViewModel with ChangeNotifier {
  final ProfileUpdateRepository _profileRepo = ProfileUpdateRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> profileUpdate({
    required BuildContext context,
    required String name,
    required String email,
    required String nav,
    File? image,
  }) async {
    _setLoading(true);

    try {
      // Ab hum Map nahi bhej rahe, direct repository ko parameters de rahe hain
      // Repository isse Multipart/Form-Data mein convert karegi
      final response = await _profileRepo.profileUpdateApi(name, email, image);

      // Aapka NetworkApiServices2 'statusCode' aur 'msg' return kar raha hai,
      // uske hisaab se response handle karte hain:
      final int statusCode = response?["statusCode"] ?? 0;
      final String message = response?["msg"] ?? "Updated successfully";

      if (statusCode == 200 || statusCode == 201) {
        if (context.mounted) {
          Toast.show(context, message);
          Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
          if(nav != "1"){      Navigator.pop(context);}
          else{
            Navigator.pushReplacementNamed(context, RoutesName.profilePendingScreen);
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