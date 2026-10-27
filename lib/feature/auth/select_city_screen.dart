// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mishtry_partner/feature/auth/view_model/select_zone_view_model.dart';
// import 'package:mishtry_partner/feature/auth/view_model/update_zone_view_model.dart';
// import 'package:mishtry_partner/feature/auth/view_model/user_view_model.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../res/app_btn.dart';
// import '../../res/banner.dart';
// import '../../res/const_color.dart';
// import '../../res/const_text.dart';
// import '../../res/custom_text_feild.dart';
// import '../model/app_session_model.dart';
// import '../model/user_session_model.dart';
//
// class SelectCityScreen extends StatefulWidget {
//   const SelectCityScreen({super.key});
//
//   @override
//   State<SelectCityScreen> createState() => _SelectCityScreenState();
// }
//
// class _SelectCityScreenState extends State<SelectCityScreen> {
//   final TextEditingController searchController = TextEditingController();
//   List<String> filteredCities = [];
//   String? selectedZoneId; // ID store karne ke liye
//   String status = "";
//   Future<void> _loadSessionFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     AppSession.session = UserSessionModel(
//       userId: prefs.getString(PrefKeys.userId),
//       token: prefs.getString(PrefKeys.token),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _loadSessionFromPrefs();
//       final String? receivedStatus = ModalRoute.of(context)?.settings.arguments as String?;
//       if (receivedStatus != null) {
//         setState(() {
//           status = receivedStatus;
//         });
//         print("Received Status: $status");
//       }
//       if (mounted) {
//         Provider.of<SelectZoneViewModel>(context, listen: false).bannerApi(context);
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
//   void _filterCities(String query, List<String> allCities) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredCities = allCities;
//       } else {
//         filteredCities = allCities
//             .where((city) => city.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: ColorConst.white,
//       resizeToAvoidBottomInset: false,
//       body: Consumer<SelectZoneViewModel>(
//         builder: (context, viewModel, child) {
//           final allZones = viewModel.bannerListData?.data.zones ?? [];
//           final allCitiesFromApi = allZones.map((e) => e.name).toList();
//
//           if (filteredCities.isEmpty && allCitiesFromApi.isNotEmpty && searchController.text.isEmpty) {
//             filteredCities = allCitiesFromApi;
//           }
//
//           bool isButtonEnabled = selectedZoneId != null;
//
//           return Stack(
//             children: [
//               const Positioned.fill(
//                 child: Column(
//                   children: [
//                     SafeArea(bottom: false, child: SizedBox(height: 0)),
//                     HomeBannerSlider(),
//                   ],
//                 ),
//               ),
// if(status == "1")
//               Positioned(
//                 top: MediaQuery.of(context).padding.top + 10,
//                 left: 16,
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
//                     child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
//                   ),
//                 ),
//               ),
//
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: AnimatedPadding(
//                   duration: const Duration(milliseconds: 150),
//                   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                       child: Container(
//                         width: double.infinity,
//                         height: screenHeight * 0.70,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//                           border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
//                         ),
//                         padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Center(child: CustomText.bold('Select Your City', fontSize: 22, color: ColorConst.black)),
//                             const SizedBox(height: 16),
//                             CustomTextField(
//                               controller: searchController,
//                               hintText: 'Search for your city...',
//                               onChanged: (val) => _filterCities(val, allCitiesFromApi),
//                             ),
//                             const SizedBox(height: 16),
//
//                             Expanded(
//                               child: viewModel.isLoading
//                                   ?  Center(child: CupertinoActivityIndicator())
//                                   : filteredCities.isEmpty
//                                   ? const Center(child: Text("No city found"))
//                                   : ListView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 itemCount: filteredCities.length,
//                                 itemBuilder: (context, index) {
//                                   final zone = allZones.firstWhere((z) => z.name == filteredCities[index]);
//                                   final isSelected = selectedZoneId == zone.id.toString();
//
//                                   return ListTile(
//                                     title: Text(zone.name, style: TextStyle(
//                                         color: isSelected ? ColorConst.green : Colors.black,
//                                         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
//                                     )),
//                                     trailing: isSelected
//                                         ? const Icon(Icons.check_circle, color: ColorConst.green) // Select hone par
//                                         : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey), // Normal state
//                                     onTap: () => setState(() => selectedZoneId = zone.id.toString()),
//                                   );
//                                 },
//                               ),
//                             ),
//
//                             Consumer<UpdateZoneViewModel>(
//                               builder: (context, zoneViewModel, child) {
//                                 return AppBtn(
//                                   title: 'Confirm City',
//                                   color: isButtonEnabled ? ColorConst.green : ColorConst.textGrey1,
//                                   onTap: isButtonEnabled && !zoneViewModel.isLoading
//                                       ? () {
//                                     zoneViewModel.selectZone(
//                                       context: context,
//                                       zoneId: selectedZoneId!,nav: status
//                                     );
//                                   }
//                                       : null,
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/auth/view_model/profile_view_model.dart'; // Import this
import 'package:mishtry_partner/feature/auth/view_model/select_zone_view_model.dart';
import 'package:mishtry_partner/feature/auth/view_model/update_zone_view_model.dart';
import 'package:mishtry_partner/feature/auth/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../res/app_btn.dart';
import '../../res/banner.dart';
import '../../res/const_color.dart';
import '../../res/const_text.dart';
import '../../res/custom_text_feild.dart';
import '../model/app_session_model.dart';
import '../model/user_session_model.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  final TextEditingController searchController = TextEditingController();
  List<String> filteredCities = [];
  String? selectedZoneId;
  String status = "";

  Future<void> _loadSessionFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    AppSession.session = UserSessionModel(
      userId: prefs.getString(PrefKeys.userId),
      token: prefs.getString(PrefKeys.token),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadSessionFromPrefs();
      final String? receivedStatus = ModalRoute.of(context)?.settings.arguments as String?;
      if (receivedStatus != null) setState(() => status = receivedStatus);

      // Fetch Zones
      await Provider.of<SelectZoneViewModel>(context, listen: false).bannerApi(context);

      // Pre-select current zone
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      final userZoneId = profileVM.serviceListData?.data?.worker?.zoneId;
      if (userZoneId != null) {
        setState(() => selectedZoneId = userZoneId.toString());
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterCities(String query, List<String> allCities) {
    setState(() {
      filteredCities = query.isEmpty
          ? allCities
          : allCities.where((city) => city.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConst.white,
      resizeToAvoidBottomInset: false,
      body: Consumer<SelectZoneViewModel>(
        builder: (context, viewModel, child) {
          final allZones = viewModel.bannerListData?.data.zones ?? [];
          final allCitiesFromApi = allZones.map((e) => e.name).toList();

          if (filteredCities.isEmpty && searchController.text.isEmpty) {
            filteredCities = allCitiesFromApi;
          }

          return Stack(
            children: [
              const Positioned.fill(child: Column(children: [SizedBox(height: 0), HomeBannerSlider()])),

              if(status == "1")
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                    ),
                  ),
                ),

              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 150),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.70,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        child: Column(
                          children: [
                            Center(child: CustomText.bold('Select Your City', fontSize: 22, color: ColorConst.black)),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: searchController,
                              hintText: 'Search for your city...',
                              onChanged: (val) => _filterCities(val, allCitiesFromApi),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: viewModel.isLoading
                                  ? const Center(child: CupertinoActivityIndicator())
                                  : ListView.builder(
                                itemCount: filteredCities.length,
                                itemBuilder: (context, index) {
                                  final zone = allZones.firstWhere((z) => z.name == filteredCities[index]);
                                  final isSelected = selectedZoneId == zone.id.toString();
                                  return ListTile(
                                    title: Text(zone.name, style: TextStyle(color: isSelected ? ColorConst.green : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                                    trailing: isSelected ? const Icon(Icons.check_circle, color: ColorConst.green) : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                                    onTap: () => setState(() => selectedZoneId = zone.id.toString()),
                                  );
                                },
                              ),
                            ),
                            Consumer<UpdateZoneViewModel>(
                              builder: (context, zoneViewModel, child) => AppBtn(
                                title: 'Confirm City',
                                color: selectedZoneId != null ? ColorConst.green : ColorConst.textGrey1,
                                onTap: selectedZoneId != null && !zoneViewModel.isLoading
                                    ? () => zoneViewModel.selectZone(context: context, zoneId: selectedZoneId!, nav: status)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}