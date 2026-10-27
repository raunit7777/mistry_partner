// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mishtry_partner/feature/auth/selct_services_screen.dart';
// import '../../res/app_btn.dart';
// import '../../res/banner.dart';
// import '../../res/const_color.dart';
// import '../../res/const_text.dart';
// import '../../res/custom_text_feild.dart';
//
// class SelectZoneScreen extends StatefulWidget {
//
//
//   const SelectZoneScreen({super.key,);
//
//   @override
//   State<SelectZoneScreen> createState() => _SelectZoneScreenState();
// }
//
// class _SelectZoneScreenState extends State<SelectZoneScreen> {
//   final TextEditingController searchController = TextEditingController();
//
//   final List<String> allZones = [
//     'Central Business District (CBD)',
//     'Civil Lines Area',
//     'Industrial Area Phase 1',
//     'Industrial Area Phase 2',
//     'North Zone / Sector A-E',
//     'South Zone / Sector F-K',
//     'East Zone Residential',
//     'West Zone Extension',
//     'Main Market Hub',
//     'Metro Station Surroundings',
//     'University Campus Zone'
//   ];
//
//   List<String> filteredZones = [];
//   String? selectedZone;
//
//   @override
//   void initState() {
//     super.initState();
//     filteredZones = allZones;
//   }
//
//
//   void _filterZones(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredZones = allZones;
//       } else {
//         filteredZones = allZones
//             .where((zone) => zone.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     bool isButtonEnabled = selectedZone != null;
//
//     return Scaffold(
//       backgroundColor: ColorConst.white,
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           // ── BACKGROUND BANNER LAYER ──
//           Positioned.fill(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SafeArea(bottom: false, child: SizedBox(height: 0)),
//                 const HomeBannerSlider(),
//               ],
//             ),
//           ),
//
//           // ── BACK BUTTON ──
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 10,
//             left: 16,
//             child: GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
//               ),
//             ),
//           ),
//
//           // ── GLASSMORPHISM ZONE BOTTOM SHEET ──
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: AnimatedPadding(
//               duration: const Duration(milliseconds: 150),
//               curve: Curves.easeOut,
//               padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                   child: Container(
//                     width: double.infinity,
//                     height: screenHeight * 0.70, // Consistent height handling
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.85),
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.3),
//                         width: 1.5,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, -5),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Center(
//                           child: Column(
//                             children: [
//                               CustomText.bold(
//                                 'Select Delivery Zone',
//                                 fontSize: 22,
//                                 color: ColorConst.black,
//                               ),
//                               const SizedBox(height: 4),
//                               // Subtitle me selected city dikhane ke liye
//                               Text(
//                                 "Showing operational zones in ${widget.selectedCity}",
//                                 style: TextStyle(
//                                   fontFamily: "Poppins",
//                                   fontSize: 12,
//                                   color: Colors.grey.shade700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Search Field for Zones
//                         CustomTextField(
//                           controller: searchController,
//                           hintText: 'Search your locality or zone...',
//                           keyboardType: TextInputType.text,
//                           fillColor: Colors.white.withOpacity(0.9),
//                           width: screenWidth - 40,
//                           prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.grey),
//                           onChanged: _filterZones,
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Dynamic Header
//                         CustomText.semiBold(
//                           searchController.text.isEmpty ? 'Available Zones' : 'Search Results',
//                           fontSize: 15,
//                           color: ColorConst.black,
//                         ),
//                         const SizedBox(height: 8),
//
//                         // Scrollable Zones List
//                         Expanded(
//                           child: filteredZones.isEmpty
//                               ? Padding(
//                             padding: const EdgeInsets.only(top: 40),
//                             child: Center(
//                               child: Text(
//                                 "We don't serve in this zone yet",
//                                 style: TextStyle(
//                                   fontFamily: "Poppins",
//                                   fontSize: 14,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                             ),
//                           )
//                               : ListView.builder(
//                             physics: const BouncingScrollPhysics(),
//                             padding: EdgeInsets.zero,
//                             itemCount: filteredZones.length,
//                             itemBuilder: (context, index) {
//                               final zoneName = filteredZones[index];
//                               final isSelected = selectedZone == zoneName;
//                               return ListTile(
//                                 contentPadding: EdgeInsets.zero,
//                                 title: Text(
//                                   zoneName,
//                                   style: TextStyle(
//                                     fontFamily: "Poppins",
//                                     fontSize: 14,
//                                     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                                     color: isSelected ? ColorConst.green : Colors.black,
//                                   ),
//                                 ),
//                                 trailing: isSelected
//                                     ? const Icon(Icons.check_circle, color: ColorConst.green)
//                                     : const Icon(Icons.map_outlined, size: 16, color: Colors.grey),
//                                 onTap: () {
//                                   setState(() {
//                                     selectedZone = zoneName;
//                                   });
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Confirm Button
//                         AppBtn(
//                           title: 'Confirm & Proceed',
//                           width: screenWidth - 40,
//                           color: isButtonEnabled ? ColorConst.green : ColorConst.textGrey1,
//                           borderRadius: 14,
//                           onTap: isButtonEnabled
//                               ? () {
//                             FocusScope.of(context).unfocus();
//                             print("Selected City: ${widget.selectedCity}, Zone: $selectedZone");
//
//
//
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(builder: (context) => const SelectServicesScreen()),
//                                   (route) => false,
//                             );
//                           }
//                               : null,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }