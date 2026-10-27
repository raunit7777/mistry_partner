// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mishtry_partner/feature/shocket/model/order_model.dart';
// import '../../../res/const_color.dart';
// import '../../outer/view/order_details.dart';
// import '../../shocket/universal_shocket.dart';
// import '../model/booking_model.dart';
//
//
// class JobCard extends StatelessWidget {
//   final Ongoing booking;
//
//   const JobCard({super.key, required this.booking});
//
//   @override
//   Widget build(BuildContext context) {
//     // Null-safe variables extract kiye
//     final serviceName = booking.service?.name ?? "Service";
//     final taskDescription = booking.taskDescription ?? "No task provided";
//     final amount = booking.totalAmount ?? 0.0;
//     final distance = booking.distance ?? "0 km";
//     final pickup = booking.pickupAddress ?? "No pickup address";
//     final drop = booking.address ?? "No drop address";
//
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => OrderDetailsScreen(booking: booking),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── HEADER ──
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(8)),
//                   child: const Icon(Icons.ac_unit_rounded, color: Color(0xFF117A65), size: 20),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(serviceName, style: TextStyle(fontFamily: "Poppins", fontSize: 13, fontWeight: FontWeight.bold, color: ColorConst.green)),
//                       const SizedBox(height: 1),
//                       Text(taskDescription, style: const TextStyle(fontFamily: "Poppins", fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black), maxLines: 2),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const Text("Target payout", style: TextStyle(fontFamily: "Poppins", fontSize: 10, color: Colors.grey)),
//                     Text("₹${amount.toStringAsFixed(0)}", style: TextStyle(fontFamily: "Poppins", fontSize: 15, fontWeight: FontWeight.bold, color: ColorConst.green)),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         const Icon(Icons.near_me_rounded, size: 10, color: Colors.grey),
//                         const SizedBox(width: 2),
//                         Text(distance, style: TextStyle(fontFamily: "Poppins", fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
//                       ],
//                     )
//                   ],
//                 )
//               ],
//             ),
//
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 10),
//               child: Divider(height: 1, color: Color(0xFFF3F4F6)),
//             ),
//
//             // ── TIMELINE ──
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   children: [
//                     const Icon(Icons.circle, size: 5, color: Colors.blue),
//                     Container(width: 1, height: 16, color: Colors.grey.shade300),
//                     const Icon(Icons.location_on_rounded, size: 9, color: Colors.red),
//                   ],
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(pickup, style: const TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
//                       const SizedBox(height: 6),
//                       Text(drop, style: TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 12),
//
//             // ── ACTION BUTTONS ──
//             Row(
//               children: [
//
//
//
//                 Expanded(
//                   flex: 6,
//                   child: InkWell(
//                     onTap: () {
//                       HapticFeedback.mediumImpact();
//                       UniversalSocketService().emitAcceptBooking(booking.bookingId ?? 0);
//                     },
//                     child: Container(
//                       height: 40,
//                       decoration: BoxDecoration(
//                           color: ColorConst.green,
//                           borderRadius: BorderRadius.circular(10),
//                           gradient: const LinearGradient(
//                               colors: [Color(0xFF00A36C), Color(0xFF117A65)],
//                               begin: Alignment.topLeft, end: Alignment.bottomRight
//                           )
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("Get Location", style: TextStyle(fontFamily: "Poppins", fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
//                           const SizedBox(width: 8),
//                           const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Colors.white),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mishtry_partner/feature/shocket/model/order_model.dart';
import '../../../res/const_color.dart';
import '../../outer/view/order_details.dart';
import '../../shocket/universal_shocket.dart';
import '../model/booking_model.dart';

class JobCard extends StatelessWidget {
  final Ongoing booking;
  final VoidCallback onRefresh; // API refresh callback

  const JobCard({super.key, required this.booking, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final serviceName = booking.service?.name ?? "Service";
    final taskDescription = booking.taskDescription ?? "No task provided";
    final amount = booking.totalAmount ?? 0.0;
    final distance = booking.distance ?? "0 km";
    final pickup = booking.pickupAddress ?? "No pickup address";
    final drop = booking.address ?? "No drop address";

    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsScreen(booking: booking))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            // ── HEADER WITH REFRESH BUTTON ──
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: ColorConst.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.ac_unit_rounded, color: ColorConst.green, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(serviceName, style: TextStyle(fontFamily: "Poppins", fontSize: 12, fontWeight: FontWeight.bold, color: ColorConst.green)),
                      Text(taskDescription, style: const TextStyle(fontFamily: "Poppins", fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                // Refresh Button
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded, size: 20, color: Colors.grey),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),

            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: Color(0xFFF5F5F5))),

            // ── TIMELINE ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(Icons.circle, size: 6, color: Colors.blue),
                    Container(width: 1, height: 18, color: Colors.grey.shade300),
                    const Icon(Icons.location_on_rounded, size: 10, color: Colors.red),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pickup, style: const TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Text(drop, style: TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),

            // ── PAYOUT & ACTION ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Payout", style: TextStyle(fontFamily: "Poppins", fontSize: 10, color: Colors.grey)),
                    Text("₹${amount.toStringAsFixed(0)}", style: TextStyle(fontFamily: "Poppins", fontSize: 16, fontWeight: FontWeight.bold, color: ColorConst.green)),
                  ],
                ),
                // InkWell(
                //   onTap: () {
                //     HapticFeedback.mediumImpact();
                //     UniversalSocketService().emitAcceptBooking(booking.bookingId ?? 0);
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       gradient: const LinearGradient(colors: [Color(0xFF00A36C), Color(0xFF117A65)]),
                //     ),
                //     child: const Text("2Accept Job", style: TextStyle(fontFamily: "Poppins", fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}