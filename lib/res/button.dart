// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:provider/provider.dart';
// // import '../../../res/const_color.dart';
// // import '../feature/auth/view_model/online_view_model.dart';
// //
// //
// // class DutyStatusToggle extends StatelessWidget {
// //   const DutyStatusToggle({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // OnlineViewModel se status listen karein
// //     return Consumer<OnlineViewModel>(
// //       builder: (context, viewModel, child) {
// //         bool isOnline = viewModel.isOnline;
// //
// //         return GestureDetector(
// //           onTap: () {
// //             HapticFeedback.mediumImpact();
// //             // Location fetch karke API call karne wala function
// //             viewModel.toggleOnlineStatus(context);
// //           },
// //           child: Container(
// //             height: 40,
// //             padding: const EdgeInsets.symmetric(horizontal: 14),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(20),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.08),
// //                   blurRadius: 6,
// //                   offset: const Offset(0, 3),
// //                 )
// //               ],
// //             ),
// //             child: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 // Status Dot
// //                 Container(
// //                   width: 8,
// //                   height: 8,
// //                   decoration: BoxDecoration(
// //                     color: isOnline ? ColorConst.green : Colors.red,
// //                     shape: BoxShape.circle,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 // Text Label
// //                 Text(
// //                   isOnline ? "ON DUTY" : "OFF DUTY",
// //                   style: const TextStyle(
// //                     fontFamily: "Poppins",
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.black,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 4),
// //                 // Dropdown Icon
// //                 const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.grey),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../../../res/const_color.dart';
// import '../feature/auth/view_model/online_view_model.dart';
// import '../feature/auth/view_model/profile_view_model.dart';
//
// class DutyStatusToggle extends StatelessWidget {
//   const DutyStatusToggle({super.key});
//
//   static const _channel = MethodChannel('rapido_background_button');
//
//   Future<void> _updateOverlay(bool isOnline) async {
//     try {
//       await _channel.invokeMethod(isOnline ? 'goOnline' : 'goOffline');
//     } catch (e) {
//       debugPrint('Overlay channel error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     // DONO ViewModel consume karein
//     return Consumer2<OnlineViewModel, ProfileViewModel>(
//       builder: (context, onlineVM, profileVM, child) {
//
//         // 1. API se status fetch karein (Agar available ho)
//         String apiAvailability = profileVM.serviceListData?.data?.worker?.availability ?? "offline";
//
//         // 2. Logic: Agar API "online" keh rahi hai, toh isOnline ko true maan lo
//         bool isOnline = apiAvailability.toLowerCase() == "online";
//
//         return GestureDetector(
//           onTap: () async {
//             HapticFeedback.mediumImpact();
//             // Status toggle karein
//             await onlineVM.toggleOnlineStatus(context);
//             // Overlay update karein
//             await _updateOverlay(onlineVM.isOnline);
//           },
//           child: Container(
//             height: 40,
//             padding: const EdgeInsets.symmetric(horizontal: 14),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 8, height: 8,
//                   decoration: BoxDecoration(
//                     color: isOnline ? ColorConst.green : Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   isOnline ? "ON DUTY" : "OFF DUTY",
//                   style: const TextStyle(fontFamily: "Poppins", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//                 const SizedBox(width: 4),
//                 const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.grey),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../res/const_color.dart';
// Import your profile update screen here
import '../feature/home/view/update_profile_screen.dart';
import '../feature/auth/view_model/online_view_model.dart';
import '../feature/auth/view_model/profile_view_model.dart';

class DutyStatusToggle extends StatelessWidget {
  const DutyStatusToggle({super.key});

  static const _channel = MethodChannel('rapido_background_button');

  Future<void> _updateOverlay(bool isOnline) async {
    try {
      await _channel.invokeMethod(isOnline ? 'goOnline' : 'goOffline');
    } catch (e) {
      debugPrint('Overlay channel error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OnlineViewModel, ProfileViewModel>(
      builder: (context, onlineVM, profileVM, child) {
        // Data fetch from ProfileViewModel
        final worker = profileVM.serviceListData?.data?.worker;
        String apiAvailability = worker?.availability ?? "offline";
        bool isOnline = apiAvailability.toLowerCase() == "online";

        return GestureDetector(
          onTap: () async {
            HapticFeedback.mediumImpact();

            // 1. Validation Logic
            final name = worker?.name;
            final image = worker?.profileImage; // Check if your model uses 'images' or 'image'

            if (name == null || name.isEmpty || image == null || image.isEmpty) {
              // Redirect to Profile Update Screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please complete your profile to go online")),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileUpdateScreen()),
              );
              return; // Stop execution
            }

            // 2. If valid, proceed to toggle status
            await onlineVM.toggleOnlineStatus(context);
            await _updateOverlay(onlineVM.isOnline);
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: isOnline ? ColorConst.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isOnline ? "ON DUTY" : "OFF DUTY",
                  style: const TextStyle(fontFamily: "Poppins", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}