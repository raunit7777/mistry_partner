// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:mishtry_partner/feature/auth/upload_aadhar_screen.dart';
// // import '../../res/app_btn.dart';
// // import '../../res/banner.dart';
// // import '../../res/const_color.dart';
// // import '../../res/const_text.dart';
// //
// // class SelectServicesScreen extends StatefulWidget {
// //   const SelectServicesScreen({super.key});
// //
// //   @override
// //   State<SelectServicesScreen> createState() => _SelectServicesScreenState();
// // }
// //
// // class _SelectServicesScreenState extends State<SelectServicesScreen> {
// //   // Category-wise tasks segregation for cleaner and professional UX
// //   final List<Map<String, dynamic>> categories = [
// //     {
// //       'categoryTitle': 'Delivery Profiles',
// //       'tasks': [
// //         {'id': '1', 'title': 'Food Delivery', 'icon': '🚴', 'isSelected': false},
// //         {'id': '2', 'title': 'Grocery Delivery', 'icon': '🛒', 'isSelected': false},
// //         {'id': '5', 'title': 'Courier / Parcel', 'icon': '📦', 'isSelected': false},
// //       ]
// //     },
// //     {
// //       'categoryTitle': 'Driving Jobs',
// //       'tasks': [
// //         {'id': '3', 'title': 'Bike Taxi Rider', 'icon': '🏍️', 'isSelected': false},
// //         {'id': '4', 'title': 'Commercial Driver', 'icon': '🚗', 'isSelected': false},
// //       ]
// //     },
// //     {
// //       'categoryTitle': 'Home Services & Skills',
// //       'tasks': [
// //         {'id': '6', 'title': 'Electrician', 'icon': '⚡', 'isSelected': false},
// //         {'id': '7', 'title': 'Professional Plumber', 'icon': '🔧', 'isSelected': false},
// //         {'id': '8', 'title': 'Home Cleaning Expert', 'icon': '🧹', 'isSelected': false},
// //         {'id': '9', 'title': 'Appliance Technician', 'icon': '🛠️', 'isSelected': false},
// //       ]
// //     }
// //   ];
// //
// //   String activeCategory = 'Delivery Profiles';
// //
// //   bool _isAnyTaskSelected() {
// //     return categories.any((cat) => (cat['tasks'] as List).any((task) => task['isSelected'] == true));
// //   }
// //
// //   List<String> _getSelectedTasks() {
// //     List<String> selected = [];
// //     for (var cat in categories) {
// //       for (var task in cat['tasks']) {
// //         if (task['isSelected'] == true) {
// //           selected.add(task['title']);
// //         }
// //       }
// //     }
// //     return selected;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     bool isButtonEnabled = _isAnyTaskSelected();
// //
// //     return Scaffold(
// //       backgroundColor: ColorConst.white,
// //       body: Stack(
// //         children: [
// //           // ── BACKGROUND BANNER LAYER ──
// //           Positioned.fill(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const SafeArea(bottom: false, child: SizedBox(height: 0)),
// //                 const HomeBannerSlider(),
// //               ],
// //             ),
// //           ),
// //
// //           // ── FULL SCREEN GLASSMORPHISM LAYER ──
// //           Positioned.fill(
// //             child: BackdropFilter(
// //               filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
// //               child: Container(
// //                 color: Colors.white.withOpacity(0.88),
// //                 child: SafeArea(
// //                   bottom: false,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Elegant Top Bar
// //                       Padding(
// //                         padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
// //                         child: Row(
// //                           children: [
// //                             GestureDetector(
// //                               onTap: () => Navigator.pop(context),
// //                               child: Container(
// //                                 padding: const EdgeInsets.all(10),
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   shape: BoxShape.circle,
// //                                   boxShadow: [
// //                                     BoxShadow(
// //                                       color: Colors.black.withOpacity(0.05),
// //                                       blurRadius: 8,
// //                                       offset: const Offset(0, 2),
// //                                     )
// //                                   ],
// //                                 ),
// //                                 child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 14),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //
// //                       // Premium Headers
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             CustomText.bold(
// //                               'Choose Your Work Profile',
// //                               fontSize: 26,
// //                               color: ColorConst.black,
// //                             ),
// //                             const SizedBox(height: 6),
// //                             Text(
// //                               "Multiple options select kar sakte hain jo kaam aapko aata hai",
// //                               style: TextStyle(
// //                                 fontFamily: "Poppins",
// //                                 fontSize: 13,
// //                                 color: Colors.grey.shade600,
// //                                 fontWeight: FontWeight.w400,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       const SizedBox(height: 12),
// //
// //                       // Horizontal Quick-Filter Category Chips
// //                       SizedBox(
// //                         height: 38,
// //                         child: ListView.builder(
// //                           scrollDirection: Axis.horizontal,
// //                           physics: const BouncingScrollPhysics(),
// //                           padding: const EdgeInsets.symmetric(horizontal: 20),
// //                           itemCount: categories.length,
// //                           itemBuilder: (context, index) {
// //                             final catName = categories[index]['categoryTitle'] as String;
// //                             final isCurrent = activeCategory == catName;
// //                             return GestureDetector(
// //                               onTap: () {
// //                                 setState(() {
// //                                   activeCategory = catName;
// //                                 });
// //                               },
// //                               child: AnimatedContainer(
// //                                 duration: const Duration(milliseconds: 200),
// //                                 margin: const EdgeInsets.only(right: 8),
// //                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                                 decoration: BoxDecoration(
// //                                   color: isCurrent ? ColorConst.black : Colors.white.withOpacity(0.6),
// //                                   borderRadius: BorderRadius.circular(20),
// //                                   border: Border.all(
// //                                     color: isCurrent ? ColorConst.black : Colors.grey.shade300,
// //                                   ),
// //                                 ),
// //                                 child: Text(
// //                                   catName,
// //                                   style: TextStyle(
// //                                     fontFamily: "Poppins",
// //                                     fontSize: 12,
// //                                     fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
// //                                     color: isCurrent ? Colors.white : Colors.grey.shade800,
// //                                   ),
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                       const SizedBox(height: 16),
// //
// //                       // Main Content Area (Scrollable Lists split by Categories)
// //                       Expanded(
// //                         child: ListView.builder(
// //                           physics: const BouncingScrollPhysics(),
// //                           padding: const EdgeInsets.fromLTRB(20, 0, 20, 100), // Extra bottom padding for floating button area
// //                           itemCount: categories.length,
// //                           itemBuilder: (context, catIdx) {
// //                             final category = categories[catIdx];
// //                             final taskList = category['tasks'] as List<Map<String, dynamic>>;
// //
// //                             return Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Padding(
// //                                   padding: const EdgeInsets.only(top: 16, bottom: 12, left: 4),
// //                                   child: CustomText.semiBold(
// //                                     category['categoryTitle'],
// //                                     fontSize: 15,
// //                                     color: ColorConst.black.withOpacity(0.8),
// //                                   ),
// //                                 ),
// //                                 GridView.builder(
// //                                   shrinkWrap: true,
// //                                   physics: const NeverScrollableScrollPhysics(),
// //                                   padding: EdgeInsets.zero,
// //                                   itemCount: taskList.length,
// //                                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                                     crossAxisCount: 2,
// //                                     crossAxisSpacing: 12,
// //                                     mainAxisSpacing: 12,
// //                                     childAspectRatio: 1.32,
// //                                   ),
// //                                   itemBuilder: (context, index) {
// //                                     final task = taskList[index];
// //                                     final isSelected = task['isSelected'] as bool;
// //
// //                                     return GestureDetector(
// //                                       onTap: () {
// //                                         setState(() {
// //                                           task['isSelected'] = !isSelected;
// //                                         });
// //                                       },
// //                                       child: AnimatedContainer(
// //                                         duration: const Duration(milliseconds: 150),
// //                                         decoration: BoxDecoration(
// //                                           color: isSelected
// //                                               ? ColorConst.green.withOpacity(0.08)
// //                                               : Colors.white,
// //                                           borderRadius: BorderRadius.circular(20),
// //                                           border: Border.all(
// //                                             color: isSelected ? ColorConst.green : Colors.white,
// //                                             width: 2,
// //                                           ),
// //                                           boxShadow: [
// //                                             BoxShadow(
// //                                               color: isSelected
// //                                                   ? ColorConst.green.withOpacity(0.1)
// //                                                   : Colors.black.withOpacity(0.03),
// //                                               blurRadius: 10,
// //                                               offset: const Offset(0, 4),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                         padding: const EdgeInsets.all(14),
// //                                         child: Stack(
// //                                           children: [
// //                                             Column(
// //                                               crossAxisAlignment: CrossAxisAlignment.start,
// //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                               children: [
// //                                                 // High Quality Custom-Look Emoji Container
// //                                                 Container(
// //                                                   padding: const EdgeInsets.all(6),
// //                                                   decoration: BoxDecoration(
// //                                                     color: isSelected
// //                                                         ? ColorConst.green.withOpacity(0.12)
// //                                                         : Colors.grey.shade50,
// //                                                     shape: BoxShape.circle,
// //                                                   ),
// //                                                   child: Text(
// //                                                     task['icon']!,
// //                                                     style: const TextStyle(fontSize: 22),
// //                                                   ),
// //                                                 ),
// //                                                 Text(
// //                                                   task['title']!,
// //                                                   maxLines: 2,
// //                                                   overflow: TextOverflow.ellipsis,
// //                                                   style: TextStyle(
// //                                                     fontFamily: "Poppins",
// //                                                     fontSize: 13,
// //                                                     fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
// //                                                     color: isSelected ? ColorConst.green : Colors.grey.shade900,
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ),
// //
// //                                             // Slick Top Right Modern Active Badge
// //                                             Positioned(
// //                                               top: 2,
// //                                               right: 2,
// //                                               child: AnimatedContainer(
// //                                                 duration: const Duration(milliseconds: 150),
// //                                                 padding: const EdgeInsets.all(4),
// //                                                 decoration: BoxDecoration(
// //                                                   color: isSelected ? ColorConst.green : Colors.grey.shade100,
// //                                                   shape: BoxShape.circle,
// //                                                 ),
// //                                                 child: Icon(
// //                                                   Icons.done,
// //                                                   size: 12,
// //                                                   color: isSelected ? Colors.white : Colors.grey.shade400,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     );
// //                                   },
// //                                 ),
// //                               ],
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           // ── FLOATING PROCEED ACTION BAR PANEL ──
// //           Align(
// //             alignment: Alignment.bottomCenter,
// //             child: ClipRRect(
// //               child: BackdropFilter(
// //                 filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
// //                 child: Container(
// //                   width: double.infinity,
// //                   padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 12),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.85),
// //                     border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1)),
// //                   ),
// //                   child: AppBtn(
// //                     title: 'Save & Proceed Profiles',
// //                     width: screenWidth - 40,
// //                     color: isButtonEnabled ? ColorConst.green : ColorConst.textGrey1,
// //                     borderRadius: 16,
// //                     onTap: isButtonEnabled
// //                         ? () {
// //                       List<String> selectedTasks = _getSelectedTasks();
// //                       print("Final Output Elements: $selectedTasks");
// //
// //                       Navigator.pushAndRemoveUntil(
// //                         context,
// //                         MaterialPageRoute(builder: (context) => const AadharUploadScreen()),
// //                             (route) => false,
// //                       );
// //
// //                     }
// //                         : null,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mishtry_partner/feature/auth/upload_aadhar_screen.dart';
// import 'package:mishtry_partner/feature/auth/view_model/service_view_model.dart';
// import 'package:mishtry_partner/feature/auth/view_model/update_service_view_model.dart';
// import 'package:provider/provider.dart';
// import '../../res/app_btn.dart';
// import '../../res/banner.dart';
// import '../../res/const_color.dart';
// import '../../res/const_text.dart';
// import 'model/service_model.dart';
//
// class SelectServicesScreen extends StatefulWidget {
//   const SelectServicesScreen({super.key});
//
//   @override
//   State<SelectServicesScreen> createState() => _SelectServicesScreenState();
// }
//
// class _SelectServicesScreenState extends State<SelectServicesScreen> {
//   Set<int> selectedServiceIds = {};
//   String activeCategory = '';
//   final String baseUrlImg = "https://mishtiry.giftaura.shop/uploads/";
//   String status = "";
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final String? receivedStatus = ModalRoute.of(context)?.settings.arguments as String?;
//       if (receivedStatus != null) {
//         setState(() {
//           status = receivedStatus;
//         });
//         print("Received Status: $status");
//       }
//       Provider.of<ServiceViewModel>(context, listen: false).serviceApi(context);
//     });
//   }
//
//   // Image URL fetcher
//   String getImageUrl(String? imagesJson) {
//     try {
//       if (imagesJson == null || imagesJson.isEmpty) return "";
//       final List<dynamic> imageList = jsonDecode(imagesJson);
//       if (imageList.isNotEmpty) {
//         return baseUrlImg + imageList.first.toString();
//       }
//     } catch (e) {
//       debugPrint("Image Load Error: $e");
//     }
//     return "";
//   }
//
//   // Fallback Icon
//   String getIcon(String catName) {
//     if (catName.contains("Appliance")) return '🛠️';
//     if (catName.contains("Beauty")) return '💄';
//     return '⚙️';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<ServiceViewModel>(context);
//     final allServices = viewModel.serviceListData?.data?.services ?? [];
//
//     Map<String, List<Services>> groupedServices = {};
//     for (var service in allServices) {
//       String cat = service.category?.name ?? "Other";
//       if (!groupedServices.containsKey(cat)) groupedServices[cat] = [];
//       groupedServices[cat]!.add(service);
//     }
//
//     if (activeCategory.isEmpty && groupedServices.isNotEmpty) {
//       activeCategory = groupedServices.keys.first;
//     }
//
//     final categoryNames = groupedServices.keys.toList();
//     final currentServices = groupedServices[activeCategory] ?? [];
//
//     return Scaffold(
//       backgroundColor: ColorConst.white,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//               child: Container(
//                 color: Colors.white.withOpacity(0.88),
//                 child: SafeArea(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomText.bold(
//                               'Choose Your Work Profile',
//                               fontSize: 24,
//                             ),
//                             const Text("Select the services you provide"),
//                           ],
//                         ),
//                       ),
//
//                       // 1. Category Chips (Horizontal List)
//                       SizedBox(
//                         height: 40,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           itemCount: categoryNames.length,
//                           itemBuilder: (context, i) {
//                             final isSelected =
//                                 activeCategory == categoryNames[i];
//                             return GestureDetector(
//                               onTap: () => setState(
//                                 () => activeCategory = categoryNames[i],
//                               ),
//                               child: Container(
//                                 margin: const EdgeInsets.only(right: 8),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? ColorConst.black
//                                       : Colors.white.withOpacity(0.6),
//                                   borderRadius: BorderRadius.circular(20),
//                                   border: Border.all(
//                                     color: isSelected
//                                         ? ColorConst.black
//                                         : Colors.grey.shade300,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   categoryNames[i],
//                                   style: TextStyle(
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//
//                       // 2. Services Grid (Main Content)
//                       Expanded(
//                         child: viewModel.isLoading
//                             ? const Center(child: CupertinoActivityIndicator())
//                             : GridView.builder(
//                                 padding: const EdgeInsets.all(20),
//                                 gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 2,
//                                       crossAxisSpacing: 12,
//                                       mainAxisSpacing: 12,
//                                       childAspectRatio: 1.1,
//                                     ),
//                                 itemCount: currentServices.length,
//                                 itemBuilder: (context, i) {
//                                   final service = currentServices[i];
//                                   final isSelected = selectedServiceIds
//                                       .contains(service.id);
//                                   final imgUrl = getImageUrl(service.images);
//
//                                   return GestureDetector(
//                                     onTap: () => setState(
//                                       () => isSelected
//                                           ? selectedServiceIds.remove(
//                                               service.id,
//                                             )
//                                           : selectedServiceIds.add(service.id!),
//                                     ),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: isSelected
//                                             ? ColorConst.green.withOpacity(0.1)
//                                             : Colors.white,
//                                         borderRadius: BorderRadius.circular(20),
//                                         border: Border.all(
//                                           color: isSelected
//                                               ? ColorConst.green
//                                               : Colors.transparent,
//                                         ),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           imgUrl.isNotEmpty
//                                               ? Image.network(
//                                                   imgUrl,
//                                                   height: 60,
//                                                   width: 60,
//                                                   fit: BoxFit.cover,
//                                                   loadingBuilder:
//                                                       (
//                                                         context,
//                                                         child,
//                                                         loadingProgress,
//                                                       ) {
//                                                         if (loadingProgress ==
//                                                             null)
//                                                           return child;
//                                                         return const SizedBox(
//                                                           height: 60,
//                                                           width: 60,
//                                                           child: Center(
//                                                             child:
//                                                                 CupertinoActivityIndicator(),
//                                                           ),
//                                                         );
//                                                       },
//                                                   errorBuilder:
//                                                       (
//                                                         context,
//                                                         error,
//                                                         stackTrace,
//                                                       ) => Text(
//                                                         getIcon(activeCategory),
//                                                         style: const TextStyle(
//                                                           fontSize: 30,
//                                                         ),
//                                                       ),
//                                                 )
//                                               : Text(
//                                                   getIcon(activeCategory),
//                                                   style: const TextStyle(
//                                                     fontSize: 30,
//                                                   ),
//                                                 ),
//                                           const SizedBox(height: 8),
//                                           Text(
//                                             service.name ?? "",
//                                             textAlign: TextAlign.center,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: AppBtn(
//                 title: 'Save & Proceed',
//                 color: selectedServiceIds.isNotEmpty
//                     ? ColorConst.green
//                     : ColorConst.textGrey1,
//                 onTap: selectedServiceIds.isNotEmpty
//                     ? () async {
//                         await context
//                             .read<UpdateServiceViewModel>()
//                             .updateServices(
//                               context: context,
//                               serviceIds: selectedServiceIds.toList(),nav: status // 1,2,3
//                             );
//                       }
//                     : null,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/app_btn.dart';
import '../../res/const_color.dart';
import '../../res/const_text.dart';
import '../auth/view_model/profile_view_model.dart';
import '../auth/view_model/service_view_model.dart';
import '../auth/view_model/update_service_view_model.dart';
import 'model/service_model.dart';

class SelectServicesScreen extends StatefulWidget {
  const SelectServicesScreen({super.key});

  @override
  State<SelectServicesScreen> createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  Set<int> selectedServiceIds = {};
  String activeCategory = '';
  final String baseUrlImg = "https://mishtiry.giftaura.shop/uploads/";
  String status = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String? receivedStatus = ModalRoute.of(context)?.settings.arguments as String?;
      if (receivedStatus != null) {
        setState(() => status = receivedStatus);
      }

      // 1. API se services aur profile data fetch karein
      await Provider.of<ServiceViewModel>(context, listen: false).serviceApi(context);

      // 2. Pre-select existing services
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      // Apne model ke hisaab se path check karein (e.g., worker ki services)
      final existingServices = profileVM.serviceListData?.data?.worker?.services ?? [];

      setState(() {
        for (var service in existingServices) {
          if (service.id != null) {
            selectedServiceIds.add(service.id!);
          }
        }
      });
    });
  }

  String getImageUrl(String? imagesJson) {
    try {
      if (imagesJson == null || imagesJson.isEmpty) return "";
      final List<dynamic> imageList = jsonDecode(imagesJson);
      if (imageList.isNotEmpty) return baseUrlImg + imageList.first.toString();
    } catch (e) {
      debugPrint("Image Load Error: $e");
    }
    return "";
  }

  String getIcon(String catName) {
    if (catName.contains("Appliance")) return '🛠️';
    if (catName.contains("Beauty")) return '💄';
    return '⚙️';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ServiceViewModel>(context);
    final allServices = viewModel.serviceListData?.data?.services ?? [];

    Map<String, List<Services>> groupedServices = {};
    for (var service in allServices) {
      String cat = service.category?.name ?? "Other";
      if (!groupedServices.containsKey(cat)) groupedServices[cat] = [];
      groupedServices[cat]!.add(service);
    }

    if (activeCategory.isEmpty && groupedServices.isNotEmpty) {
      activeCategory = groupedServices.keys.first;
    }

    final categoryNames = groupedServices.keys.toList();
    final currentServices = groupedServices[activeCategory] ?? [];

    return Scaffold(
      backgroundColor: ColorConst.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                color: Colors.white.withOpacity(0.88),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.bold('Choose Your Work Profile', fontSize: 24),
                            const Text("Select the services you provide"),
                          ],
                        ),
                      ),
                      // Category Chips
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: categoryNames.length,
                          itemBuilder: (context, i) {
                            final isSelected = activeCategory == categoryNames[i];
                            return GestureDetector(
                              onTap: () => setState(() => activeCategory = categoryNames[i]),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? ColorConst.black : Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isSelected ? ColorConst.black : Colors.grey.shade300),
                                ),
                                child: Text(categoryNames[i], style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                              ),
                            );
                          },
                        ),
                      ),
                      // Services Grid
                      Expanded(
                        child: viewModel.isLoading
                            ? const Center(child: CupertinoActivityIndicator())
                            : GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1,
                          ),
                          itemCount: currentServices.length,
                          itemBuilder: (context, i) {
                            final service = currentServices[i];
                            final isSelected = selectedServiceIds.contains(service.id);
                            final imgUrl = getImageUrl(service.images);

                            return GestureDetector(
                              onTap: () => setState(() => isSelected ? selectedServiceIds.remove(service.id) : selectedServiceIds.add(service.id!)),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? ColorConst.green.withOpacity(0.1) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isSelected ? ColorConst.green : Colors.transparent, width: 2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    imgUrl.isNotEmpty
                                        ? Image.network(imgUrl, height: 60, width: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Text(getIcon(activeCategory), style: const TextStyle(fontSize: 30)))
                                        : Text(getIcon(activeCategory), style: const TextStyle(fontSize: 30)),
                                    const SizedBox(height: 8),
                                    Text(service.name ?? "", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AppBtn(
                title: 'Save & Proceed',
                color: selectedServiceIds.isNotEmpty ? ColorConst.green : ColorConst.textGrey1,
                onTap: selectedServiceIds.isNotEmpty
                    ? () async {
                  await context.read<UpdateServiceViewModel>().updateServices(
                    context: context,
                    serviceIds: selectedServiceIds.toList(),
                    nav: status,
                  );
                }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}