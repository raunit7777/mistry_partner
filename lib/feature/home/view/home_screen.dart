import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:mishtry_partner/confic/utils/routes/routes_name.dart';
import 'package:mishtry_partner/feature/auth/view_model/profile_view_model.dart';
import 'package:mishtry_partner/feature/home/view/today_over_view_screen.dart';
import 'package:mishtry_partner/feature/home/view_model/get_dash_bord.dart';
import 'package:provider/provider.dart';
import '../../../../res/app_btn.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';
import '../../../res/button.dart';
import '../../auth/view_model/booking_view_model.dart';
import '../../booking/view_model/booking_view_model.dart';
import '../../booking/weget/job_card.dart';
import '../../notification/notification_view_model/notification_view_model.dart';
import '../../order/view/order_deatails_screen.dart';
import '../../outer/view/notifcation_screen.dart';
import '../../shocket/view_model/view_model_order.dart';
import '../view_model/Overview_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnline = true; // Kept default to match image status "ON DUTY"
  GoogleMapController? _mapController;

  static const LatLng _technicianLocation = LatLng(26.8467, 80.9462);
  static const LatLng _jobLocationA = LatLng(26.8520, 80.9490);
  static const LatLng _jobLocationB = LatLng(26.8210, 80.9940);

  static const CameraPosition _initialPosition = CameraPosition(
    target: _technicianLocation,
    zoom: 13.5,
  );




  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
final vm = Provider.of<ProfileViewModel>(context,).serviceListData?.data?.worker;
    Set<Marker> _jobMarkers = {
      Marker(
        markerId: const MarkerId('technician_current_base'),
        position: _technicianLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _isOnline ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
      ),
    };
final vm2 = Provider.of<NotificationViewModel>(context,listen: false);
final v2 = Provider.of<GetDashBord>(context,listen: false).serviceListData?.data;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Off-white clean layout tone
      body: Stack(
        children: [
          // ── LAYER 1: FULL SCREEN LIVE MAP BASE ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.58, // Expanded map view tracking context perfectly
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              myLocationEnabled: _isOnline,
              zoomControlsEnabled: false,
              markers: _jobMarkers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),

          // ── LAYER 2: TOP FLOATING COMPONENT HEADER OVERLAY ──
          Positioned(
            top: topPadding + 6,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Circular/Rectangular Drawer Trigger Button
               SizedBox(height: 50,width: 40,),
                DutyStatusToggle(),

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
              ],
            ),
          ),

          // ── LAYER 3: DOUBLE RIGHT FLOATING CONTROLS (LOCATOR & SOS) ──
          Positioned(
            top: screenHeight * 0.22,
            right: 14,
            child: Column(
              children: [
                // Locating Control Tracker Box
                _buildSidebarFloatingButton(
                  child: const Icon(Icons.my_location_rounded, color: Colors.black, size: 20),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _mapController?.animateCamera(CameraUpdate.newLatLng(_technicianLocation));
                  },
                ),
                const SizedBox(height: 12),

                // SOS Panic System Round Core Button
                _buildSidebarFloatingButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_moderator_rounded, color: Colors.red.shade600, size: 18),
                      const SizedBox(height: 1),
                      Text(
                        "SOS",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 9, fontWeight: FontWeight.bold, color: Colors.red.shade600),
                      )
                    ],
                  ),
                  onTap: () => HapticFeedback.heavyImpact(),
                ),
              ],
            ),
          ),

          // ── LAYER 4: INTERACTIONS SUMMARY COMPACT DRAG BOTTOM SHEET PANEL ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: screenWidth,
              padding: EdgeInsets.fromLTRB(14, 12, 14, bottomPadding + 14),
              decoration: const BoxDecoration(
                color: Color(0xFFF4F6F9), // Matching image panel separation tint
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Top Drag handle line marker element
                  Center(
                    child: Container(
                      width: 36,
                      height: 3.5,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  // ── WIDGET A: TODAY'S OVERVIEW BOARD (EXACT LAYOUT CARD) ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText.bold("Today's Overview", fontSize: 13, color: Colors.black),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                // OrderDetailsScreen mein jahan aap navigate kar rahe hain
                             Navigator.pushNamed(context, RoutesName.todayOverviewScreen);
                              },
                              child: CustomText.bold("View All", fontSize: 12, color: ColorConst.green),
                            ),                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // 1. Earnings (Default: 0)
                            _buildOverviewMetricColumn(
                                "Earnings",
                                "₹${v2?.today?.earning ?? 0}",
                                IconlyBold.wallet,
                                const Color(0xFFE8F8F5),
                                ColorConst.green
                            ),
                            _buildVerticalDivider(),

                            // 2. Jobs Done (Agar dono null hain toh 0/0)
                            _buildOverviewMetricColumn(
                                "Jobs Done",
                                "${v2?.today?.jobsDone ?? 0}/${v2?.today?.jobsDone ?? 0}",
                                IconlyBold.activity,
                                const Color(0xFFEBF5FB),
                                const Color(0xFF2471A3)
                            ),
                            _buildVerticalDivider(),

                            // 3. Rating (Default: 0.0)
                            _buildOverviewMetricColumn(
                                "Rating",
                                "${(v2?.today?.rating ?? 0).toString()}",
                                Icons.star_rounded,
                                const Color(0xFFFEF9E7),
                                const Color(0xFFFFBF00)
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── WIDGET B: ALLOCATION JOB CARDS GRID ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.bold("New Booking Allocation", fontSize: 14, color: Colors.black),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: ColorConst.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text("New", style: TextStyle(fontFamily: "Poppins", fontSize: 10, fontWeight: FontWeight.bold, color: ColorConst.green)),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Consumer<ViewModelOrder>(
                    builder: (context, vm, child) {
                      // 1. Loading check
                      if (vm.isLoading) {
                        return const Center(child: CupertinoActivityIndicator());
                      }

                      // 2. Data check
                      final ongoingBooking = vm.serviceListData?.data?.ongoing;

                      // 3. Agar koi booking nahi hai, toh Text + Refresh Button dikhayein
                      if (ongoingBooking == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("No active bookings", style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 10),
                              TextButton.icon(
                                onPressed: () => vm.serviceApi(context), // API call trigger
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text("Refresh"),
                                style: TextButton.styleFrom(
                                  foregroundColor: ColorConst.green, // Apna green color use karein
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // 4. Booking hone par JobCard
                      return JobCard(
                        booking: ongoingBooking,
                        onRefresh: () => vm.serviceApi(context),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Builder Helper for Floating Action Rounded Header boxes
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

  // Builder Helper for Circular Custom Sidebar Floating Controllers
  Widget _buildSidebarFloatingButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44, width: 44,
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  // Column generator utility helper for Today's Overview Widget area
  Widget _buildOverviewMetricColumn(String title, String value, IconData icon, Color bg, Color iconColor) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
              child: Icon(icon, size: 14, color: iconColor),
            ),
            const SizedBox(width: 6),
            Text(title, style: TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontFamily: "Poppins", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 28, color: Colors.grey.shade200);
  }
}