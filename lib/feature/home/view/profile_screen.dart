//
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:mishtry_partner/feature/home/view/poy_screen.dart';
import 'package:mishtry_partner/res/aap_urls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../res/app_btn.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';
import '../../../confic/utils/routes/routes_name.dart';
import '../../auth/login_screen.dart';
import '../../auth/view_model/profile_view_model.dart';
import '../../auth/view_model/user_view_model.dart' show PrefKeys, UserViewModel;
import '../../model/app_session_model.dart';
import '../../model/user_session_model.dart';
import '../view_model/get_dash_bord.dart';
import '../view_model/pravcay_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
      Provider.of<PravcayViewModel>(context, listen: false).bookingApi(context);
      Provider.of<GetDashBord>(context, listen: false).profileApi(context);
    });
  }
  Future<void> _loadSessionFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    AppSession.session = UserSessionModel(
      userId: prefs.getString(PrefKeys.userId),
      token: prefs.getString(PrefKeys.token),
    );
  }
  Future<void> _refreshProfile(BuildContext context) async {
    _loadSessionFromPrefs();
    await Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
    await Provider.of<PravcayViewModel>(context, listen: false).bookingApi(context);
    await   Provider.of<GetDashBord>(context, listen: false).profileApi(context);
  }IconData _getIconData(String? slug) {
    switch (slug?.toLowerCase()) {
      case 'terms-of-services': return IconlyLight.document;
      case 'privacy-policy': return IconlyLight.shield_done;
      case 'refund-policy': return IconlyLight.wallet;
      case 'about-us': return IconlyLight.info_circle;
      default: return IconlyLight.info_square;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context).serviceListData;
    final screenWidth = MediaQuery.of(context).size.width;
    final policesVm = Provider.of<PravcayViewModel>(context);
    final policiesList = policesVm.bannerListData?.data?.policies ?? [];
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: const SizedBox(),
        title: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: CustomText.bold(
            'My Account Profile',
            fontSize: 22,
            color: ColorConst.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProfile(context),
        color: ColorConst.green,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            children: [
              // ── 1. PREMIUM GREEN ACCENTED SERVICE MAN OVERVIEW CARD ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: ColorConst.green.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white,
                            child: ClipOval( // Image ko circle mein crop karne ke liye
                              child: Image.network(
                                "${AppUrl.baseUrlImg}/${vm?.data?.worker?.profileImage ?? ""}",
                                width: 64, // CircleAvatar ka diameter (32*2)
                                height: 64,
                                fit: BoxFit.cover, // Image ko stretch hone se bachane ke liye
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CupertinoActivityIndicator(), // Yahan 'const' hatayein
                                    );
                                  },
                                errorBuilder: (context, error, stackTrace) {
                                  // Agar image load nahi hui toh fallback icon
                                  return const Icon(IconlyBold.profile, color: ColorConst.green, size: 34);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText.bold(
                                vm?.data?.worker?.name ?? "Loading...",
                                fontSize: 18,
                                color: ColorConst.black,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Partner ID: ${vm?.data?.worker?.id ?? "N/A"}",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                vm?.data?.worker?.phone ?? "---",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFBF00).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFFFBF00), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                vm?.data?.worker?.rating?.toString() ?? "0",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32, color: Color(0xFFF3F4F6)),
                    Text(
                      "Verified Work Specializations",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: (vm?.data?.worker?.services ?? []).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: ColorConst.green.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorConst.green.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            skill.name ?? "",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ColorConst.green,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // ── QUICK STATS ──
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("Wallet", "₹${vm?.data?.worker?.wallet}", Colors.blue.shade700),
                    Container(width: 1, height: 30, color: Colors.grey.shade200),

                    _buildStatItem("Rating", "${vm?.data?.worker?.rating}", const Color(0xFFFFBF00)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Account Settings"),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildProfileMenuTile(
                      icon: IconlyLight.profile,
                      accentColor: const Color(0xFF2471A3),
                      title: "Manage Personal Info",
                      subtitle: "Edit name, contact phone, and avatar configurations",
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.profileUpdateScreen);
                      },
                    ),
                    _buildProfileMenuTile(
                      icon: IconlyLight.wallet,
                      accentColor: ColorConst.green,
                      title: "Payout Settings & Banking",
                      subtitle: "Manage dynamic wallet parameters and deposits",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutesName.bankDetailsScreen,

                        );

                      },
                    ),
                    _buildProfileMenuTile(
                      icon: IconlyLight.category,
                      accentColor: ColorConst.green,
                      title: "Update Services",
                      subtitle: "Manage your professional service categories",
                      onTap: () {
                        Navigator.pushNamed(
                            context,
                            RoutesName.selectServicesScreen,
                            arguments: "1" // Status "1" bheja
                        );
                      },
                    ),

                    // 2. Select Zone
                    _buildProfileMenuTile(
                      icon: IconlyLight.location,
                      accentColor: const Color(0xFF2471A3),
                      title: "Select Operational Zone",
                      subtitle: "Update your preferred service area",
                      onTap: () {
                        Navigator.pushNamed(
                            context,
                            RoutesName.selectZoneScreen,
                            arguments: "1" // Status "1" bheja
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── DYNAMIC POLICY & SUPPORT SECTION ──
              _buildSectionTitle("Support, Training & Safety"),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: policesVm.isLoading
                    ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CupertinoActivityIndicator()),
                )
                    : policiesList.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("No policies available", style: TextStyle(color: Colors.grey))),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: policiesList.length,
                  itemBuilder: (context, index) {
                    final policy = policiesList[index];
                    return _buildProfileMenuTile(
                      icon: _getIconData(policy.slug),
                      accentColor: Colors.teal,
                      title: policy.title ?? "Policy",
                      subtitle: "View our ${policy.title ?? 'details'}",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PolicyDetailScreen(slug: policy.slug),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 36),
              AppBtn(
                title: "Logout Account",
                color: Colors.red.withOpacity(0.08),
                titleColor: Colors.red.shade700,
                borderRadius: 16,
                width: screenWidth - 32,
                onTap: () {
                  HapticFeedback.heavyImpact();
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: CustomText.semiBold(
          title,
          fontSize: 14,
          color: ColorConst.black.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenuTile({
    required IconData icon,
    required Color accentColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subtitle,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }
}  void _showLogoutDialog(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (BuildContext sheetContext) {
      return Container(
        padding: EdgeInsets.all(width * 0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Icon(
              Icons.logout_rounded,
              color: ColorConst.orange,
              size: 40,
            ),
            SizedBox(height: height * 0.02),
            CustomText.bold("Log Out?", fontSize: 20),
            SizedBox(height: height * 0.01),
            CustomText.regular(
              "Are you sure you want to log out of your account?",
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
              fontSize: 14,
            ),
            SizedBox(height: height * 0.04),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: CustomText.semiBold("Stay", color: ColorConst.black),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("🗑️ Session tokens clearing initialized...");
                      final prefs = UserViewModel();
                      await prefs.removeUser();

                      if (context.mounted) {

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.orange,
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: CustomText.semiBold("LOGOUT", color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
          ],
        ),
      );
    },
  );
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:iconly/iconly.dart';
// import 'package:mishtry_partner/feature/home/view/poy_screen.dart';
// import 'package:mishtry_partner/res/aap_urls.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // Apne sahi paths import karein
// import '../../../../res/app_btn.dart';
// import '../../../../res/const_color.dart';
// import '../../../../res/const_text.dart';
// import '../../../confic/utils/routes/routes_name.dart';
// import '../../auth/login_screen.dart';
// import '../../auth/view_model/profile_view_model.dart';
// import '../../auth/view_model/user_view_model.dart';
// import '../../model/app_session_model.dart';
// import '../../model/user_session_model.dart';
// // Policies ke imports
//
// import '../../order/view_model/polyciy_view_model.dart';
// import '../view_model/pravcay_view_model.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<PravcayViewModel>(context, listen: false).bookingApi(context);
//       Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
//       // Provider.of<PolicesViewModel>(context, listen: false).bookingApi(context);
//     });
//   }
//
//   Future<void> _loadSessionFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     AppSession.session = UserSessionModel(
//       userId: prefs.getString(PrefKeys.userId),
//       token: prefs.getString(PrefKeys.token),
//     );
//   }
//
//   Future<void> _refreshProfile(BuildContext context) async {
//     await _loadSessionFromPrefs();
//     if (context.mounted) {
//       await Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
//       await Provider.of<PravcayViewModel>(context, listen: false).bookingApi(context);
//     }
//   }
//
//   IconData _getIconData(String? slug) {
//     switch (slug?.toLowerCase()) {
//       case 'terms-of-services': return IconlyLight.document;
//       case 'privacy-policy': return IconlyLight.shield_done;
//       case 'refund-policy': return IconlyLight.wallet;
//       case 'about-us': return IconlyLight.info_circle;
//       default: return IconlyLight.info_square;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<ProfileViewModel>(context).serviceListData;
//     final policesVm = Provider.of<PravcayViewModel>(context);
//     final policiesList = policesVm.bannerListData?.data?.policies ?? [];
//
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         centerTitle: false,
//         leading: const SizedBox(),
//         title: Padding(
//           padding: const EdgeInsets.only(left: 4),
//           child: CustomText.bold('My Account Profile', fontSize: 22, color: ColorConst.black),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => _refreshProfile(context),
//         color: ColorConst.green,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
//           child: Column(
//             children: [
//               // ── PROFILE CARD ──
//               _buildProfileHeader(vm),
//               const SizedBox(height: 20),
//
//               // ── QUICK STATS ──
//               _buildQuickStats(vm),
//               const SizedBox(height: 24),
//
//               // ── ACCOUNT SETTINGS ──
//               _buildSectionTitle("Account Settings"),
//               const SizedBox(height: 8),
//               _buildAccountSettings(),
//
//               const SizedBox(height: 24),
//
//               // ── DYNAMIC SUPPORT SECTION ──
//               _buildSectionTitle("Support, Training & Safety"),
//               const SizedBox(height: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 8), // Thodi breathing space
//                 child: policesVm.isLoading
//                     ? const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Center(child: CupertinoActivityIndicator()),
//                 )
//                     : ListView.builder(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero, // List ki default padding hatayi
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: policiesList.length,
//                   itemBuilder: (context, index) {
//                     final policy = policiesList[index];
//                     return _buildProfileMenuTile(
//                       icon: _getIconData(policy.slug),
//                       accentColor: Colors.teal,
//                       title: policy.title ?? "Policy",
//                       subtitle: "View our ${policy.title ?? 'details'}",
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PolicyDetailScreen(slug: policy.slug),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 36),
//               AppBtn(
//                 title: "Logout Account",
//                 color: Colors.red.withOpacity(0.08),
//                 titleColor: Colors.red.shade700,
//                 borderRadius: 16,
//                 width: screenWidth - 32,
//                 onTap: () {
//                   HapticFeedback.heavyImpact();
//                   _showLogoutDialog(context);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- Helper Widgets Methods ---
//   Widget _buildProfileHeader(var vm) => Container(
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
//     child: Row(
//       children: [
//         CircleAvatar(radius: 32, backgroundImage: NetworkImage("${AppUrl.baseUrlImg}/${vm?.data?.worker?.profileImage ?? ""}")),
//         const SizedBox(width: 16),
//         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           CustomText.bold(vm?.data?.worker?.name ?? "Loading...", fontSize: 18),
//           Text("ID: ${vm?.data?.worker?.id ?? "N/A"}", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//         ])),
//       ],
//     ),
//   );
//
//   Widget _buildQuickStats(var vm) => Container(
//     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
//     child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//       _buildStatItem("Wallet", "₹${vm?.data?.worker?.wallet ?? "0"}", Colors.blue.shade700),
//       Container(width: 1, height: 30, color: Colors.grey.shade200),
//       _buildStatItem("Rating", "${vm?.data?.worker?.rating ?? "0"}", const Color(0xFFFFBF00)),
//     ]),
//   );
//
//   Widget _buildAccountSettings() => Container(
//     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
//     child: Column(children: [
//       _buildProfileMenuTile(icon: IconlyLight.profile, accentColor: const Color(0xFF2471A3), title: "Manage Personal Info", subtitle: "Edit profile details", onTap: () => Navigator.pushNamed(context, RoutesName.profileUpdateScreen)),
//       _buildProfileMenuTile(icon: IconlyLight.wallet, accentColor: ColorConst.green, title: "Payout Settings", subtitle: "Manage bank details", onTap: () => Navigator.pushNamed(context, RoutesName.bankDetailsScreen)),
//       _buildProfileMenuTile(icon: IconlyLight.category, accentColor: ColorConst.green, title: "Update Services", subtitle: "Manage categories", onTap: () => Navigator.pushNamed(context, RoutesName.selectServicesScreen, arguments: "1")),
//     ]),
//   );
//
//   Widget _buildSectionTitle(String title) => Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(left: 4), child: CustomText.semiBold(title, fontSize: 14, color: Colors.black54)));
//
//   Widget _buildStatItem(String label, String value, Color valueColor) => Column(children: [Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)), const SizedBox(height: 4), Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor))]);
//
//   Widget _buildProfileMenuTile({required IconData icon, required Color accentColor, required String title, required String subtitle, required VoidCallback onTap}) => ListTile(
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//     leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: accentColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: accentColor, size: 20)),
//     title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//     subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
//     trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
//     onTap: onTap,
//   );
//
//   void _showLogoutDialog(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;
//
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       builder: (BuildContext sheetContext) {
//         return Container(
//           padding: EdgeInsets.all(width * 0.06),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               const Icon(
//                 Icons.logout_rounded,
//                 color: ColorConst.orange,
//                 size: 40,
//               ),
//               SizedBox(height: height * 0.02),
//               CustomText.bold("Log Out?", fontSize: 20),
//               SizedBox(height: height * 0.01),
//               CustomText.regular(
//                 "Are you sure you want to log out of your account?",
//                 color: Colors.grey.shade600,
//                 textAlign: TextAlign.center,
//                 fontSize: 14,
//               ),
//               SizedBox(height: height * 0.04),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.of(sheetContext).pop(),
//                       style: OutlinedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(vertical: height * 0.015),
//                         side: BorderSide(color: Colors.grey.shade300),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: CustomText.semiBold("Stay", color: ColorConst.black),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         print("🗑️ Session tokens clearing initialized...");
//                         final prefs = UserViewModel();
//                         await prefs.removeUser();
//
//                         if (context.mounted) {
//
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LoginScreen(),
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorConst.orange,
//                         padding: EdgeInsets.symmetric(vertical: height * 0.015),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: CustomText.semiBold("LOGOUT", color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: height * 0.01),
//             ],
//           ),
//         );
//       },
//     );
//   }}