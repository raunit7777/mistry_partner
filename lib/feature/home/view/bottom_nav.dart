import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:mishtry_partner/feature/home/view/profile_screen.dart';
import 'package:mishtry_partner/feature/notification/notification_view_model/notification_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../../res/const_color.dart';
import '../../../res/const_text.dart';
import '../../auth/view_model/user_view_model.dart';
import '../../booking/view_model/booking_view_model.dart';
import '../../model/app_session_model.dart';
import '../../model/user_session_model.dart';
import '../../shocket/universal_shocket.dart';
import '../view_model/get_dash_bord.dart';
import 'home_screen.dart';
import 'order_screen.dart';


class NewBottomNav extends StatefulWidget {
  const NewBottomNav({super.key});

  @override
  State<NewBottomNav> createState() => _NewBottomNavState();
}

class _NewBottomNavState extends State<NewBottomNav> {
  int _currentIndex = 0;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadSessionFromPrefs();

      if (AppSession.session != null && AppSession.session!.token != null) {
        debugPrint("✅ Session Loaded. Initializing APIs...");

        if (mounted) {
          // listen: false lagana mandatory hai initState mein
          final bookingVm = Provider.of<BookingViewModel2>(context, listen: false);
          final dashVm = Provider.of<GetDashBord>(context, listen: false);

          // API Calls
          dashVm.profileApi(context);

          // Socket connection
          UniversalSocketService().connect(bookingVm);
        }
      } else {
        debugPrint("❌ Session Load Failed.");
      }
    });
  }
  Future<void> _loadSessionFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    AppSession.session = UserSessionModel(
      userId: prefs.getString(PrefKeys.userId),
      token: prefs.getString(PrefKeys.token),
    );
  }


  // View mapping layer panels supporting the newly added profile panel
  final List<Widget> _pages = [
    const HomeScreen(),
    const BookingHistoryScreen(),
    const ProfileScreen(), // Profile screen added to tracking matrix index 2
  ];

  // Handle system hardware back click action routing logic
  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    } else {
      return await _showExitDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool shouldExit = await _onWillPop();
        if (shouldExit && context.mounted) {
          if (Platform.isAndroid) {
            SystemNavigator.pop(); // Close app cleanly on Android
          } else {
            exit(0);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        extendBody: true, // Content scrolls beautifully behind the floating bar
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),

        // ── FLOATING CAPSULE NAVIGATION MODULE ──
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            height: 68,
            width: screenWidth,
            margin: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding > 0 ? 8 : 16),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDynamicTabItem(
                  icon: IconlyLight.home,
                  activeIcon: IconlyBold.home,
                  label: "Home",
                  index: 0,
                  width: screenWidth,
                ),
                _buildDynamicTabItem(
                  icon: IconlyLight.document,
                  activeIcon: IconlyBold.document,
                  label: "Orders",
                  index: 1,
                  width: screenWidth,
                ),
                _buildDynamicTabItem(
                  icon: IconlyLight.profile,
                  activeIcon: IconlyBold.profile,
                  label: "Profile",
                  index: 2,
                  width: screenWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ── FLEXIBLE DYNAMIC SHIFT TAB BAR CONTAINER ROW MODULE ──
  Widget _buildDynamicTabItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required double width,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact(); // Soft touch haptic pulse feedback
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        // Sizing factors balanced for a clean three-column configuration layout
        width: isSelected ? (width * 0.34) : (width * 0.18),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00A36C).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected ? const Color(0xFF00A36C) : Colors.grey.shade500,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00A36C),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


Future<bool> _showExitDialog(context) async {
  final bool? shouldExit = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (sheetContext) {
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
            const Icon(Icons.logout_rounded, color: ColorConst.orange, size: 40),
            SizedBox(height: height * 0.02),
            CustomText.bold("Exit App?", fontSize: 20),
            SizedBox(height: height * 0.01),
            CustomText.regular(
              "Are you sure you want to exit the app?",
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
              fontSize: 14,
            ),
            SizedBox(height: height * 0.04),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(sheetContext).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: CustomText.semiBold("Stay", color: ColorConst.black),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(sheetContext).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.orange,
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: CustomText.semiBold("EXIT", color: Colors.white),
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

  return shouldExit ?? false;
}