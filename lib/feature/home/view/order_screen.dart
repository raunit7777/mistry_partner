// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:iconly/iconly.dart';
// import '../../../../res/app_btn.dart';
// import '../../../../res/const_color.dart';
// import '../../../../res/const_text.dart';
// import 'order_summary_screen.dart';
//
// class BookingHistoryScreen extends StatefulWidget {
//   const BookingHistoryScreen({super.key});
//
//   @override
//   State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
// }
//
// class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
//   String _selectedFilter = "All";
//   final List<String> _filters = ["All", "Completed", "Cancelled", "Upcoming"];
//
//   final List<Map<String, dynamic>> _bookingLogs = [
//     {
//       "id": "#MS-8921",
//       "category": "AC Repair & Service",
//       "serviceDetail": "Split AC Deep Jet Cleaning (1.5 Ton)",
//       "time": "Today, 11:24 AM",
//       "price": "₹549",
//       "status": "COMPLETED",
//       "pickup": "Hazratganj Main Chauraha, Lucknow",
//       "drop": "HCL IT City, Sultanpur Road",
//       "iconBg": Color(0xFFE8F8F5),
//       "iconColor": Color(0xFF117A65),
//       "typeIcon": Icons.ac_unit_rounded,
//     },
//     {
//       "id": "#MS-8842",
//       "category": "Cooler Technician",
//       "serviceDetail": "Desert Cooler Pump Replacement & Oil Check",
//       "time": "Yesterday, 06:15 PM",
//       "price": "₹380",
//       "status": "COMPLETED",
//       "pickup": "Charbagh Railway Station, Platform 1",
//       "drop": "Indira Nagar Sector 14, Near Church",
//       "iconBg": Color(0xFFEBF5FB),
//       "iconColor": Color(0xFF2980B9),
//       "typeIcon": Icons.wind_power_rounded,
//     },
//     {
//       "id": "#MS-8799",
//       "category": "Appliance Maintenance",
//       "serviceDetail": "Fully Automatic Washing Machine Service",
//       "time": "08 May 2024, 02:30 PM",
//       "price": "₹450",
//       "status": "CANCELLED",
//       "pickup": "Aliganj Sector Q, Near Post Office",
//       "drop": "Aliganj, Lucknow",
//       "iconBg": Color(0xFFFEF5E7),
//       "iconColor": Color(0xFFE67E22),
//       "typeIcon": Icons.local_laundry_service_rounded,
//     }
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         scrolledUnderElevation: 0,
// leading: SizedBox(),
//         title: CustomText.bold(
//           'Booking History Logs',
//           fontSize: 20,
//           color: ColorConst.black,
//         ),
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(IconlyLight.notification, color: Colors.black, size: 24),
//                 onPressed: () {},
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//                   child: const Text(
//                     '3',
//                     style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: Column(
//         children: [
//           // ── HORIZONTAL SCROLLABLE FILTER CHIPS SECTION ──
//           Container(
//             color: Colors.white,
//             height: 54, // Compressed height
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               itemCount: _filters.length,
//               itemBuilder: (context, index) {
//                 final filterName = _filters[index];
//                 final isSelected = _selectedFilter == filterName;
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8),
//                   child: GestureDetector(
//                     onTap: () {
//                       HapticFeedback.lightImpact();
//                       setState(() {
//                         _selectedFilter = filterName;
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: isSelected ? ColorConst.green : Colors.transparent,
//                         borderRadius: BorderRadius.circular(8), // Made rectangular
//                         border: Border.all(
//                           color: isSelected ? ColorConst.green : const Color(0xFFE5E7EB),
//                           width: 1,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           filterName,
//                           style: TextStyle(
//                             fontFamily: "Poppins",
//                             fontSize: 13,
//                             fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                             color: isSelected ? Colors.white : const Color(0xFF117A65),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // ── LIVE FILTRATION SEARCH AND FILTER BAR GRID ──
//           Padding(
//             // Top aur bottom padding ko minimal kiya hai taaki vertical space bache
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Container(
//               height: 40, // Perfectly compact rectangular height
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8), // Sharp rectangular corners
//                 border: Border.all(color: const Color(0xFFE5E7EB)),
//               ),
//               child: const TextField(
//                 textAlignVertical: TextAlignVertical.center, // Text ko perfectly center me rkhne ke liye
//                 style: TextStyle(fontFamily: "Poppins", fontSize: 13, color: Colors.black),
//                 decoration: InputDecoration(
//                   hintText: "Search services, locations...",
//                   hintStyle: TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.grey),
//                   prefixIcon: Icon(IconlyLight.search, color: Colors.grey, size: 16),
//                   border: InputBorder.none,
//                   isDense: true, // Extra default padding ko eliminate karta hai
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Balanced inner spacing
//                 ),
//               ),
//             ),
//           ),
//
//           // ── CORE RECTANGULAR LOG BOOK DATA RENDER LIST ──
//           Expanded(
//             child: ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.fromLTRB(16, 6, 16, 100),
//               itemCount: _bookingLogs.length,
//               itemBuilder: (context, index) {
//                 final log = _bookingLogs[index];
//                 final isCancelled = log["status"] == "CANCELLED";
//
//                 return GestureDetector(     onTap: () {
//     HapticFeedback.lightImpact();
//
//     // Navigating to Summary Screen and passing the log data map
//     Navigator.push(
//     context,
//     MaterialPageRoute(
//     builder: (context) => BookingSummaryScreen(
//     orderDetails: {
//     'orderId': log["id"],
//     'serviceType': log["category"],
//     'jobDetail': log["serviceDetail"],
//     'dateTime': log["time"],
//     'price': log["price"],
//     'pickupLoc': log["pickup"],
//     'dropLoc': log["drop"],
//     'status': log["status"] == "COMPLETED" ? "Completed" : "Cancelled",
//     },
//     ),
//     ),
//     );
//
//
//                   Row(
//                     children: [
//                       Text(
//                         "View Summary",
//                         style: TextStyle(
//                           fontFamily: "Poppins",
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                           color: ColorConst.green,
//                         ),
//                       ),
//                       const SizedBox(width: 2),
//                       Icon(Icons.arrow_forward_ios_rounded, size: 8, color: ColorConst.green)
//                     ],
//                   );
//                 },
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     padding: const EdgeInsets.all(12), // Halved padding
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10), // Sharp Rectangular look
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.01),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         )
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header Layout block
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 40, // Compressed icon area
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: log["iconBg"],
//                                 borderRadius: BorderRadius.circular(8), // Rectangular Icon box
//                               ),
//                               child: Icon(log["typeIcon"], color: log["iconColor"], size: 20),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomText.bold(log["category"], fontSize: 14, color: ColorConst.black),
//                                   const SizedBox(height: 1),
//                                   Text(
//                                     log["serviceDetail"],
//                                     style: TextStyle(
//                                       fontFamily: "Poppins",
//                                       fontSize: 11,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     log["time"],
//                                     style: TextStyle(
//                                       fontFamily: "Poppins",
//                                       fontSize: 10,
//                                       color: Colors.grey.shade400,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       log["price"],
//                                       style: TextStyle(
//                                         fontFamily: "Poppins",
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                         color: isCancelled ? Colors.red.shade700 : const Color(0xFF117A65),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 2),
//                                     const Icon(Icons.more_vert_rounded, size: 16, color: Colors.grey),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                   decoration: BoxDecoration(
//                                     color: isCancelled
//                                         ? Colors.red.withOpacity(0.08)
//                                         : ColorConst.green.withOpacity(0.08),
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: Text(
//                                     log["status"],
//                                     style: TextStyle(
//                                       fontFamily: "Poppins",
//                                       fontSize: 9,
//                                       fontWeight: FontWeight.bold,
//                                       color: isCancelled ? Colors.red.shade700 : ColorConst.green,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//
//                         const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 8), // Halved Divider spacing
//                           child: Divider(height: 1, color: Color(0xFFF3F4F6)),
//                         ),
//
//                         // Stepper Layout
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Column(
//                               children: [
//                                 const Icon(Icons.circle, size: 6, color: Colors.blue),
//                                 Container(width: 1, height: 18, color: Colors.grey.shade300), // Shorter line
//                                 const Icon(Icons.location_on_rounded, size: 10, color: Colors.red),
//                               ],
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     log["pickup"],
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                       fontFamily: "Poppins",
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6), // Shorter distance gap
//                                   Text(
//                                     log["drop"],
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontFamily: "Poppins",
//                                       fontSize: 11,
//                                       color: Colors.grey.shade500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//
//                         const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 8),
//                           child: Divider(height: 1, color: Color(0xFFF3F4F6)),
//                         ),
//
//                         // Footer elements
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Booking ID: ${log["id"]}",
//                               style: TextStyle(
//                                 fontFamily: "Poppins",
//                                 fontSize: 11,
//                                 color: Colors.grey.shade400,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {},
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     "View Summary",
//                                     style: TextStyle(
//                                       fontFamily: "Poppins",
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.bold,
//                                       color: ColorConst.green,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 2),
//                                   Icon(Icons.arrow_forward_ios_rounded, size: 8, color: ColorConst.green)
//                                 ],
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: () {
//       //     HapticFeedback.mediumImpact();
//       //   },
//       //   backgroundColor: ColorConst.green,
//       //   elevation: 3,
//       //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rectangular FAB
//       //   icon: const Icon(Icons.add, color: Colors.white),
//       //   label: const Text(
//       //     "Book Now",
//       //     style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white),
//       //   ),
//       // ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:mishtry_partner/feature/payment/view_model/get_details_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../res/app_btn.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';
import '../../auth/view_model/booking_view_model.dart';
import '../../notification/notification_view_model/notification_view_model.dart';
import '../../outer/view/notifcation_screen.dart';
import '../view_model/get_dash_bord.dart';
import 'order_summary_screen.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Completed", "Cancelled", "Upcoming"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingViewModel>(context, listen: false).serviceApi(context);
      Provider.of<GetDashBord>(context, listen: false).profileApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BookingViewModel>(context);
    List<dynamic> allBookings = vm.serviceListData?.data?.bookings ?? [];
    final vm2 = Provider.of<NotificationViewModel>(context,listen: false);
// 2. Filter apply karein
    List<dynamic> filteredBookings = allBookings.where((log) {
      if (_selectedFilter == "All") return true;

      // Status check (API response ke mutabik)
      String status = log.status?.toLowerCase() ?? "";

      if (_selectedFilter == "Completed") return status == "completed";
      if (_selectedFilter == "Cancelled") return status == "cancelled";
      if (_selectedFilter == "Upcoming") return status == "pending";

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const SizedBox(),
        title: CustomText.bold(
          'Booking History Logs',
          fontSize: 20,
          color: ColorConst.black,
        ),
        actions: [
          Stack(
            children: [
              _buildFloatingTopActionButton(
                icon: IconlyLight.notification,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
              ),// Condition: Agar unreadCount null nahi hai aur 0 se bada hai
              if ((vm2.serviceListData?.data?.unreadCount ?? 0) > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      // Sirf tabhi dikhaye jab count > 0 ho
                      vm2.serviceListData!.data!.unreadCount.toString(),
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 54,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filterName = _filters[index];
                final isSelected = _selectedFilter == filterName;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedFilter = filterName);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? ColorConst.green : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? ColorConst.green : const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          filterName,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF117A65),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const TextField(
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(fontFamily: "Poppins", fontSize: 13, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Search services, locations...",
                  hintStyle: TextStyle(fontFamily: "Poppins", fontSize: 12, color: Colors.grey),
                  prefixIcon: Icon(IconlyLight.search, color: Colors.grey, size: 16),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
          ),
          // ... (UPAR KA SARA CODE SAME HAI)

          Expanded(
            child: vm.isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : RefreshIndicator(
              onRefresh: () => Provider.of<BookingViewModel>(context, listen: false).serviceApi(context),
              color: ColorConst.green,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 100),
                // ✅ FIX: filteredBookings ka count use karein
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  // ✅ FIX: filteredBookings se log uthayein
                  final log = filteredBookings[index];
                  final isCancelled = log.status?.toUpperCase() == "CANCELLED";

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingSummaryScreen(
                            orderDetails: {
                              'orderId': "#${log.id ?? "0"}",
                              'serviceType': log.service?.name ?? "Service",
                              'jobDetail': log.service?.description ?? "No details",
                              'dateTime': log.bookingDate ?? "N/A",
                              'price': "₹${log.totalAmount ?? "0"}",
                              'pickupLoc': log.address ?? "Location not found",
                              'dropLoc': "Lucknow",
                              'status': log.status ?? "Pending",
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      // ✅ BAAKI KA UI DESIGN BILKUL WAHI HAI, KOI CHANGE NAHI
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.build_rounded, color: Color(0xFF117A65), size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText.bold(log.service?.name ?? "Service", fontSize: 14, color: ColorConst.black),
                                    Text(log.service?.description ?? "", style: TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey.shade600)),
                                    Text(log.bookingDate ?? "", style: TextStyle(fontFamily: "Poppins", fontSize: 10, color: Colors.grey.shade400)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("₹${log.totalAmount ?? "0"}", style: TextStyle(fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.bold, color: isCancelled ? Colors.red.shade700 : ColorConst.green)),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isCancelled ? Colors.red.withOpacity(0.08) : ColorConst.green.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(log.status?.toUpperCase() ?? "N/A", style: TextStyle(fontFamily: "Poppins", fontSize: 9, fontWeight: FontWeight.bold, color: isCancelled ? Colors.red.shade700 : ColorConst.green)),
                                  )
                                ],
                              )
                            ],
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: Color(0xFFF3F4F6))),
                          // ... Timeline aur Footer code waisa hi hai
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
                                    Text(log.address ?? "No address", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: "Poppins", fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                                    const SizedBox(height: 6),
                                    Text("Lucknow", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey.shade500)),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: Color(0xFFF3F4F6))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Booking ID: #${log.id ?? "0"}", style: TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                              Row(
                                children: [
                                  Text("View Summary", style: TextStyle(fontFamily: "Poppins", fontSize: 11, fontWeight: FontWeight.bold, color: ColorConst.green)),
                                  const SizedBox(width: 2),
                                  const Icon(Icons.arrow_forward_ios_rounded, size: 8, color: ColorConst.green)
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )

        ],
      ),
    );
  }
}

Widget _buildFloatingTopActionButton({required IconData icon, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40, width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 3))
        ],
      ),
      child: Icon(icon, color: Colors.black87, size: 20),
    ),
  );
}
