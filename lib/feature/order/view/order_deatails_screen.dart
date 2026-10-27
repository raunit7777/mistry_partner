import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import '../../../../res/app_btn.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';

class ActiveOrderScreen extends StatefulWidget {
  final Map<String, dynamic> orderDetails;

  const ActiveOrderScreen({super.key, required this.orderDetails});

  @override
  State<ActiveOrderScreen> createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {
  GoogleMapController? _mapController;

  // 0 = En Route to Pickup, 1 = Arrived / Job Started, 2 = Job Done
  int _currentOrderStep = 0;

  static const LatLng _technicianLocation = LatLng(26.8467, 80.9462);
  static const LatLng _customerLocation = LatLng(26.8520, 80.9490);

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _updateOrderWorkflowStep() {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_currentOrderStep < 2) {
        _currentOrderStep++;
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job session processed and closed successfully!'),
            backgroundColor: Colors.teal,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Set<Marker> _trackingMarkers = {
      Marker(
        markerId: const MarkerId('driver_current_location'),
        position: _technicianLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('customer_service_location'),
        position: _customerLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    // Dynamic Gradients & Labels based on workflow progress
    String workflowButtonText = "Arrived at Location";
    List<Color> gradientColors = [const Color(0xFF00A36C), const Color(0xFF117A65)];
    IconData actionIcon = Icons.directions_run_rounded;

    if (_currentOrderStep == 1) {
      workflowButtonText = "Start Service Task";
      gradientColors = [const Color(0xFF2471A3), const Color(0xFF1A5276)];
      actionIcon = Icons.play_arrow_rounded;
    } else if (_currentOrderStep == 2) {
      workflowButtonText = "Mark Job as Completed";
      gradientColors = [const Color(0xFFE67E22), const Color(0xFFCA6F1E)];
      actionIcon = Icons.verified_rounded;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Stack(
        children: [
          // ── LAYER 1: LIVE MAP VIEW ENGINE ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.54,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(target: _customerLocation, zoom: 14.5),
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: _trackingMarkers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),

          // ── LAYER 2: FLOATING TOP COMPONENT OVERLAY ──
          Positioned(
            top: topPadding + 6,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40, width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 3))],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 14),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 3))],
                  ),
                  child: Row(
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF00A36C), shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      CustomText.bold("Live Tracking Active", fontSize: 11, color: Colors.black),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // ── LAYER 3: FLOATING INTERACTIVE HUD SHEET ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: screenWidth,
              padding: EdgeInsets.fromLTRB(14, 12, 14, bottomPadding + 14),
              decoration: BoxDecoration(
                color: Colors.white, // Shifted to crisp premium white
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36, height: 3.5,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  // ── WIDGET A: CUSTOMER HUD CONNECT INTERFACE ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColorConst.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.ac_unit_rounded, color: Color(0xFF117A65), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText.bold(widget.orderDetails['serviceType'] ?? "AC Specialist Job", fontSize: 14, color: Colors.black),
                              const SizedBox(height: 2),
                              Text(
                                "Order Reference: ${widget.orderDetails['orderId'] ?? '#MS-8921'}",
                                style: TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => HapticFeedback.lightImpact(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: ColorConst.green.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                            child: Icon(IconlyBold.call, color: ColorConst.green, size: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── WIDGET B: TIMELINE MAP ROUTING INTERFACE ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText.bold("Destination Tracking Path", fontSize: 12, color: Colors.grey.shade500),
                            Text(
                              widget.orderDetails['price'] ?? "₹0",
                              style: TextStyle(fontFamily: "Poppins", fontSize: 16, fontWeight: FontWeight.bold, color: ColorConst.green),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Premium custom trailing dash path/dots
                            Column(
                              children: [
                                const SizedBox(height: 3),
                                const Icon(Icons.circle, size: 6, color: Colors.blue),
                                const SizedBox(height: 2),
                                ...List.generate(3, (index) => Container(
                                  margin: const EdgeInsets.symmetric(vertical: 1.5),
                                  width: 1, height: 4,
                                  color: Colors.grey.shade300,
                                )),
                                const SizedBox(height: 2),
                                const Icon(Icons.location_on_rounded, size: 11, color: Colors.red),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.orderDetails['pickupLoc'] ?? "Hazratganj Main Chauraha, Lucknow",
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontFamily: "Poppins", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.orderDetails['dropLoc'] ?? "HCL IT City, Sultanpur Road",
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── WIDGET C: ACTION SYSTEM WORKFLOW PULSE BUTTON ──
                  InkWell(
                    onTap: _updateOrderWorkflowStep,
                    child: Container(
                      height: 42,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(color: gradientColors.first.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 3))
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(actionIcon, size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            workflowButtonText,
                            style: const TextStyle(fontFamily: "Poppins", fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                            child: const Icon(Icons.arrow_forward_ios_rounded, size: 8, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}