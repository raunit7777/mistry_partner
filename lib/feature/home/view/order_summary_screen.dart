// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:iconly/iconly.dart';
// import '../../../../res/app_btn.dart';
// import '../../../../res/const_color.dart';
// import '../../../../res/const_text.dart';
//
// class BookingSummaryScreen extends StatelessWidget {
//   final Map<String, dynamic> orderDetails;
//
//   const BookingSummaryScreen({super.key, required this.orderDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     // Normalize string checks safely
//     final currentStatus = orderDetails['status']?.toString().toLowerCase() ?? '';
//     final isCompleted = currentStatus == 'completed' || currentStatus == 'success';
//
//     final statusColor = isCompleted ? ColorConst.green : Colors.red.shade700;
//     final bannerBg = isCompleted ? ColorConst.green.withOpacity(0.04) : Colors.red.withOpacity(0.04);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6F9), // Sophisticated light backdrop match
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         centerTitle: false,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: GestureDetector(
//             onTap: () {
//               HapticFeedback.lightImpact();
//               Navigator.pop(context);
//             },
//             child: Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF3F4F6),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 12),
//             ),
//           ),
//         ),
//         title: CustomText.bold(
//           'Booking Summary',
//           fontSize: 18,
//           color: ColorConst.black,
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.all(14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   // ── 1. PREMIUM ACCENTED STATUS SUMMARY BANNER ──
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.03),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         )
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: bannerBg,
//                           border: Border(
//                             left: BorderSide(color: statusColor, width: 4), // Heavy status color accent
//                           ),
//                         ),
//                         padding: const EdgeInsets.all(16),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: isCompleted
//                                     ? ColorConst.green.withOpacity(0.1)
//                                     : Colors.red.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Icon(
//                                 isCompleted ? Icons.check_circle_rounded : Icons.cancel_rounded,
//                                 color: statusColor,
//                                 size: 28,
//                               ),
//                             ),
//                             const SizedBox(width: 14),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomText.bold(
//                                     isCompleted ? "Job Completed Successfully" : "Booking Cancelled",
//                                     fontSize: 15,
//                                     color: ColorConst.black,
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     "Booking ID: ${orderDetails['orderId']}",
//                                     style: const TextStyle(
//                                       fontFamily: "Poppins",
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // ── 2. SERVICE RENDERED LAYER WITH PREMIUM DETAIL CONTAINER ──
//                   _buildSectionTitle("Service Rendered"),
//                   const SizedBox(height: 6),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.02),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         )
//                       ],
//                       border: Border.all(color: const Color(0xFFE5E7EB)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CustomText.bold(orderDetails['serviceType']!, fontSize: 14, color: ColorConst.black),
//                             Icon(IconlyLight.work, size: 16, color: statusColor),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           orderDetails['jobDetail']!,
//                           style: TextStyle(
//                             fontFamily: "Poppins",
//                             fontSize: 12,
//                             color: Colors.grey.shade700,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           child: Divider(height: 1, color: Color(0xFFF3F4F6)),
//                         ),
//                         _buildMetaRow(IconlyLight.calendar, "Date & Time", orderDetails['dateTime']!),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // ── 3. TIMELINE ROUTE LOCATION TRACKING LAYER ──
//                   _buildSectionTitle("Location Details"),
//                   const SizedBox(height: 6),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.02),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         )
//                       ],
//                       border: Border.all(color: const Color(0xFFE5E7EB)),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Dotted customized timeline track path layout frame
//                         Column(
//                           children: [
//                             const SizedBox(height: 4),
//                             const Icon(Icons.circle, size: 6, color: Colors.blue),
//                             const SizedBox(height: 2),
//                             ...List.generate(4, (index) => Container(
//                               margin: const EdgeInsets.symmetric(vertical: 1.5),
//                               width: 1,
//                               height: 4,
//                               color: Colors.grey.shade300,
//                             )),
//                             const SizedBox(height: 2),
//                             const Icon(Icons.location_on_rounded, size: 11, color: Colors.red),
//                           ],
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Pickup / Store Location",
//                                 style: TextStyle(
//                                   fontFamily: "Poppins",
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey.shade400,
//                                 ),
//                               ),
//                               const SizedBox(height: 1),
//                               CustomText.medium(orderDetails['pickupLoc']!, fontSize: 12, color: ColorConst.black, maxLines: 1),
//                               const SizedBox(height: 14),
//                               Text(
//                                 "Customer Drop Address",
//                                 style: TextStyle(
//                                   fontFamily: "Poppins",
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey.shade400,
//                                 ),
//                               ),
//                               const SizedBox(height: 1),
//                               CustomText.medium(orderDetails['dropLoc']!, fontSize: 12, color: ColorConst.black, maxLines: 1),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // ── 4. RECEIPT-STYLE PAYMENT BREAKDOWN MODULE ──
//                   _buildSectionTitle("Payment Breakdown"),
//                   const SizedBox(height: 6),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.02),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         )
//                       ],
//                       border: Border.all(color: const Color(0xFFE5E7EB)),
//                     ),
//                     child: Column(
//                       children: [
//                         _buildInvoiceRow("Base Service Charge", orderDetails['price']!),
//                         _buildInvoiceRow("Conveyance / Travel Fee", "₹50"),
//                         _buildInvoiceRow("Platform Taxes & GST", "₹25"),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           child: Divider(height: 1, color: Color(0xFFF3F4F6)),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 const Icon(IconlyLight.wallet, size: 16, color: Colors.grey),
//                                 const SizedBox(width: 6),
//                                 CustomText.bold("Total Settled Earnings", fontSize: 13, color: ColorConst.black),
//                               ],
//                             ),
//                             CustomText.bold(
//                               "₹${(int.tryParse(orderDetails['price']!.replaceAll('₹', '').replaceAll(',', '')) ?? 0) + 75}",
//                               fontSize: 16,
//                               color: statusColor,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ),
//
//           // ── RECTANGULAR FIXED FOOTER DISMISSAL BUTTON ──
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//             child: AppBtn(
//               title: "Dismiss Summary",
//               color: statusColor, // Synchronized with active task color logic
//               borderRadius: 8,
//               width: screenWidth - 32,
//               onTap: () {
//                 HapticFeedback.lightImpact();
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Section Heading Builder Helper
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 4, bottom: 2),
//       child: CustomText.semiBold(
//         title,
//         fontSize: 13,
//         color: ColorConst.black.withOpacity(0.6),
//       ),
//     );
//   }
//
//   // Mini Informational Meta row helper
//   Widget _buildMetaRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 14, color: Colors.grey.shade500),
//         const SizedBox(width: 6),
//         Text(
//           "$label: ",
//           style: TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
//         ),
//         Text(
//           value,
//           style: const TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
//
//   // Bill Item Invoice row helper
//   Widget _buildInvoiceRow(String label, String cost) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
//           ),
//           Text(
//             cost,
//             style: const TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import '../../../../res/app_btn.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';

class BookingSummaryScreen extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  const BookingSummaryScreen({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Normalize string checks safely
    final currentStatus = orderDetails['status']?.toString().toLowerCase() ?? '';
    final isCompleted = currentStatus == 'completed' || currentStatus == 'success';

    final statusColor = isCompleted ? ColorConst.green : Colors.red.shade700;
    final bannerBg = isCompleted ? ColorConst.green.withOpacity(0.04) : Colors.red.withOpacity(0.04);

    // Dynamic Calculation Logic
    final rawPrice = orderDetails['price']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? "0";
    final double totalAmount = double.tryParse(rawPrice) ?? 0.0;

    // Yahan agar aapke paas specific fields backend se aa rahi hain, to use replace karein
    final double gst = totalAmount * 0.05;
    final double travelFee = totalAmount * 0.02;
    final double basePrice = totalAmount - gst - travelFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 12),
            ),
          ),
        ),
        title: CustomText.bold(
          'Booking Summary',
          fontSize: 18,
          color: ColorConst.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Status Banner
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bannerBg,
                          border: Border(left: BorderSide(color: statusColor, width: 4)),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: isCompleted ? ColorConst.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Icon(isCompleted ? Icons.check_circle_rounded : Icons.cancel_rounded, color: statusColor, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText.bold(isCompleted ? "Job Completed Successfully" : "Booking Cancelled", fontSize: 15, color: ColorConst.black),
                                  Text("Booking ID: ${orderDetails['orderId']}", style: const TextStyle(fontFamily: "Poppins", fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Service Rendered
                  _buildSectionTitle("Service Rendered"),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          CustomText.bold(orderDetails['serviceType']!, fontSize: 14, color: ColorConst.black),
                          Icon(IconlyLight.work, size: 16, color: statusColor),
                        ]),
                        const SizedBox(height: 4),
                        Text(orderDetails['jobDetail']!, style: TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: Color(0xFFF3F4F6))),
                        _buildMetaRow(IconlyLight.calendar, "Date & Time", orderDetails['dateTime']!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Location Details
                  _buildSectionTitle("Location Details"),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(children: [
                          const SizedBox(height: 4),
                          const Icon(Icons.circle, size: 6, color: Colors.blue),
                          ...List.generate(4, (index) => Container(margin: const EdgeInsets.symmetric(vertical: 1.5), width: 1, height: 4, color: Colors.grey.shade300)),
                          const Icon(Icons.location_on_rounded, size: 11, color: Colors.red),
                        ]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("Pickup / Store Location", style: TextStyle(fontFamily: "Poppins", fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                            CustomText.medium(orderDetails['pickupLoc']!, fontSize: 12, color: ColorConst.black, maxLines: 1),
                            const SizedBox(height: 14),
                            Text("Customer Drop Address", style: TextStyle(fontFamily: "Poppins", fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                            CustomText.medium(orderDetails['dropLoc']!, fontSize: 12, color: ColorConst.black, maxLines: 1),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Payment Breakdown
                  _buildSectionTitle("Payment Breakdown"),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
                    child: Column(
                      children: [
                        _buildInvoiceRow("Base Service Charge", "₹${basePrice.toStringAsFixed(0)}"),
                        _buildInvoiceRow("Conveyance / Travel Fee", "₹${travelFee.toStringAsFixed(0)}"),
                        _buildInvoiceRow("Platform Taxes & GST", "₹${gst.toStringAsFixed(0)}"),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: Color(0xFFF3F4F6))),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(children: [
                            const Icon(IconlyLight.wallet, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            CustomText.bold("Total Settled Earnings", fontSize: 13, color: ColorConst.black),
                          ]),
                          CustomText.bold("₹${totalAmount.toStringAsFixed(0)}", fontSize: 16, color: statusColor),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: AppBtn(
              title: "Dismiss Summary",
              color: statusColor,
              borderRadius: 8,
              width: screenWidth - 32,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(padding: const EdgeInsets.only(left: 4, bottom: 2), child: CustomText.semiBold(title, fontSize: 13, color: ColorConst.black.withOpacity(0.6)));

  Widget _buildMetaRow(IconData icon, String label, String value) => Row(children: [
    Icon(icon, size: 14, color: Colors.grey.shade500),
    const SizedBox(width: 6),
    Text("$label: ", style: TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
    Text(value, style: const TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
  ]);

  Widget _buildInvoiceRow(String label, String cost) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
    Text(cost, style: const TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
  ]));
}