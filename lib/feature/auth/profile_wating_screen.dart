import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mishtry_partner/feature/auth/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import '../../confic/utils/toast.dart';
import '../../res/app_btn.dart';
import '../../res/banner.dart';
import '../../res/const_color.dart';
import '../../res/const_text.dart';
import '../home/view/bottom_nav.dart';

class ProfilePendingScreen extends StatefulWidget {
  const ProfilePendingScreen({super.key});

  @override
  State<ProfilePendingScreen> createState() => _ProfilePendingScreenState();
}

class _ProfilePendingScreenState extends State<ProfilePendingScreen> {
  bool isAccountActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkAccountStatus();
      if (mounted) {
        Provider.of<ProfileViewModel>(context, listen: false).profileApi(context);
      }
    });
  }

  Future<void> checkAccountStatus() async {
    final profileProvider = Provider.of<ProfileViewModel>(context, listen: false);

    // 1. Nayi API call karein taaki updated status mil sake
    await profileProvider.profileApi(context);

    // 2. Updated data se status extract karein
    final worker = profileProvider.serviceListData?.data?.worker;
    final status = worker?.status; // "pending" ya "approved"
    final isActive = worker?.isActive;

    if (mounted) {
      if (status == "approved") {
        // Status Approved hai -> Home par bhej dein
        setState(() {
          isAccountActive = true;
        });
        // Optional: Automatic navigation
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const NewBottomNav()), (route) => false);
      } else {
        // Status Pending hai -> Toast dikhayein
        setState(() {
          isAccountActive = false;
        });
        Toast.show(context, "Verification is still pending with the admin.", backgroundColor: Colors.orange);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConst.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: checkAccountStatus,
          color: ColorConst.green,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  const Spacer(),
                  // Status Header
                  Center(
                    child: Container(
                      width: 140, height: 140,
                      decoration: BoxDecoration(
                        color: isAccountActive ? ColorConst.green.withOpacity(0.08) : ColorConst.orange.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(color: isAccountActive ? ColorConst.green.withOpacity(0.2) : ColorConst.orange.withOpacity(0.2), width: 4),
                      ),
                      child: Center(child: Text(isAccountActive ? "✅" : "⏳", style: const TextStyle(fontSize: 48))),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Text Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        CustomText.bold(isAccountActive ? 'Profile Verified!' : 'Profile Verification Pending', fontSize: 24, color: ColorConst.black, textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text(
                          isAccountActive ? "Congratulations! Your profile has been approved." : "Your work profile is under review by our administration team. It will activate automatically upon approval.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Timeline
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200, width: 1.5)),
                    child: Column(
                      children: [
                        _buildTimelineStep(icon: Icons.check_circle, iconColor: ColorConst.green, title: "Registration Form Submitted", description: "All metrics captured.", isLast: false),
                        _buildTimelineStep(icon: Icons.radio_button_checked, iconColor: isAccountActive ? ColorConst.green : ColorConst.orange, title: isAccountActive ? "Profile Approved" : "Admin Approval in Progress", description: "Identity under review.", isLast: false, showLoadingLine: !isAccountActive),
                        _buildTimelineStep(icon: Icons.circle_outlined, iconColor: isAccountActive ? ColorConst.green : Colors.grey.shade400, title: "Account Ready to Earn", description: "Dashboard opens instantly.", isLast: true),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Footer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        AppBtn(
                          title: isAccountActive ? 'Go to Dashboard' : 'Verification Pending',
                          width: screenWidth - 48,
                          color: isAccountActive ? ColorConst.green : ColorConst.textGrey1,
                          borderRadius: 16,
                          onTap: isAccountActive ? () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const NewBottomNav()), (route) => false) : null,
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: checkAccountStatus,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, size: 16, color: Colors.grey.shade700),
                              const SizedBox(width: 6),
                              Text("Refresh Account Status", style: TextStyle(fontFamily: "Poppins", fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700, decoration: TextDecoration.underline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep({required IconData icon, required Color iconColor, required String title, required String description, required bool isLast, bool showLoadingLine = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          Icon(icon, color: iconColor, size: 22),
          if (!isLast) Container(width: 2, height: 38, color: showLoadingLine ? ColorConst.orange.withOpacity(0.3) : ColorConst.green),
        ]),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
              Text(description, style: TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey.shade600, height: 1.3)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}