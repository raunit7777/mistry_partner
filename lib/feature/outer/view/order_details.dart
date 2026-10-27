import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../order/view/add_on_screen.dart';
import '../../order/view_model/get_addon_view_model.dart';
import '../../order/view_model/order_complete_view_model.dart';
import '../../shocket/view_model/view_model_order.dart';

class OrderDetailsScreen extends StatefulWidget {
  final dynamic booking;
  const OrderDetailsScreen({super.key, this.booking});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
        (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  // ─── Custom Date & Time Formatter (DD-MM-YYYY & AM/PM) ───
  String _formatDateTime(String? rawDateTime) {
    if (rawDateTime == null || rawDateTime.isEmpty) return 'N/A';
    try {
      // String ko DateTime object mein convert kar rahe hain
      DateTime dateTime = DateTime.parse(rawDateTime).toLocal();

      // Date Format: DD-MM-YYYY
      String day = dateTime.day.toString().padLeft(2, '0');
      String month = dateTime.month.toString().padLeft(2, '0');
      String year = dateTime.year.toString();
      String formattedDate = "$day-$month-$year";

      // Time Format: 12-Hour with AM/PM
      int hour = dateTime.hour;
      String period = hour >= 12 ? "PM" : "AM";
      hour = hour % 12;
      hour = hour == 0 ? 12 : hour; // 0 ko 12 banana padega
      String minute = dateTime.minute.toString().padLeft(2, '0');
      String formattedTime = "${hour.toString().padLeft(2, '0')}:$minute $period";

      return "$formattedDate | $formattedTime";
    } catch (e) {
      // Agar backend se normal date text format aa raha ho jo parse na ho sake
      return rawDateTime;
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid phone number")),
      );
      return;
    }

    final Uri launchUri = Uri(scheme: 'tel', path: cleanedNumber);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ongoingBookingId = widget.booking?.bookingId ?? widget.booking?.id;

      if (ongoingBookingId != null) {
        Provider.of<GetAddonViewModel>(context, listen: false)
            .profileApi(context, ongoingBookingId.toString());
      } else {
        final vm = Provider.of<ViewModelOrder>(context, listen: false);
        vm.serviceApi(context).then((_) {
          final backupId = vm.serviceListData?.data?.ongoing?.bookingId;
          if (backupId != null) {
            Provider.of<GetAddonViewModel>(context, listen: false)
                .profileApi(context, backupId.toString());
          }
        });
      }
    });
  }

  @override
  void dispose() {
    for (var c in _otpControllers) c.dispose();
    for (var f in _otpFocusNodes) f.dispose();
    super.dispose();
  }

  Future<void> _launchGoogleMaps(String? address) async {
    if (address == null || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address details not available")),
      );
      return;
    }

    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}",
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch map")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final picheKaBookingId = widget.booking?.bookingId ?? widget.booking?.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManualAddonScreen(
                    serviceId: picheKaBookingId?.toString(),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF22C55E),
              size: 18,
            ),
            label: const Text(
              'Add Add-ons',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
      body: Consumer<GetAddonViewModel>(
        builder: (context, addonVm, child) {
          if (addonVm.isLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final b = addonVm.serviceListData?.data?.booking;
          if (b == null) {
            return const Center(child: Text("No Data Found"));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      _buildOrderHeader(b),
                      const SizedBox(height: 10),
                      _buildServiceDetails(b.service, b.bookingDate, b.notes),
                      const SizedBox(height: 10),
                      _buildAddonsSection(b.addons),
                      const SizedBox(height: 10),
                      _buildCustomerDetails(b.user),
                      const SizedBox(height: 10),
                      _buildPaymentDetails(b),
                      const SizedBox(height: 10),
                      _buildLocationDetails(b),
                      const SizedBox(height: 10),
                      _buildOtpSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(b),
            ],
          );
        },
      ),
    );
  }

  // ─── 1. Order ID & Main Status ────────────────────────
  Widget _buildOrderHeader(dynamic b) {
    return _card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.assignment_outlined, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Order ID: ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: "Poppins"),
              ),
            ],
          ),
          Text(
            '${b.id ?? 'N/A'}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: "Poppins"),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${b.status ?? 'N/A'}'.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF15803D),
                fontWeight: FontWeight.w700,
                fontSize: 11,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 2. Service Info & Schedule (Formatted Date/Time Applied Here) ───
  Widget _buildServiceDetails(dynamic service, String? bookingDate, String? notes) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.build_circle_outlined, color: Color(0xFF22C55E), size: 18),
              SizedBox(width: 8),
              Text(
                'Service Information',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: "Poppins"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow('Service Name', service?.name ?? 'N/A'),
          _infoRow('Est. Time', service?.estimatedTime ?? 'N/A'),
          // ✅ Yahan humne dynamic custom parse apply kiya h
          _infoRow('Schedule At', _formatDateTime(bookingDate)),
          if (service?.description != null && service!.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF), fontFamily: "Poppins"),
            ),
            Text(
              '${service.description}',
              style: const TextStyle(fontSize: 12, color: Colors.black87, fontFamily: "Poppins"),
            ),
          ],
          if (notes != null && notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes from User:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E), fontFamily: "Poppins"),
                  ),
                  Text(
                    notes,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF78350F), fontFamily: "Poppins"),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  // ─── 3. Add-ons List ─────────────────────────────────
  Widget _buildAddonsSection(List<dynamic>? addons) {
    if (addons == null || addons.isEmpty) {
      return const SizedBox.shrink();
    }

    double totalAddonPrice = 0;
    for (var addon in addons) {
      totalAddonPrice += double.tryParse(addon.price?.toString() ?? '0') ?? 0;
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.add_shopping_cart, color: Color(0xFF22C55E), size: 18),
              SizedBox(width: 8),
              Text(
                'Added Add-ons',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: "Poppins"),
              ),
            ],
          ),
          const SizedBox(),
          ...addons.map(
                (addon) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    addon.name ?? 'Add-on',
                    style: const TextStyle(fontSize: 12, fontFamily: "Poppins"),
                  ),
                  Text(
                    '₹${addon.price ?? '0'}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Add-ons',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: "Poppins"),
              ),
              Text(
                '₹${totalAddonPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF22C55E),
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── 4. Customer Info ────────────────────────────────
  Widget _buildCustomerDetails(dynamic user) {
    return _card(
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE0F2FE),
            child: Icon(Icons.person_outline, color: Color(0xFF0369A1)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customer Details',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF), fontFamily: "Poppins"),
                ),
                Text(
                  user?.name ?? 'Unknown Customer',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: "Poppins"),
                ),
                Text(
                  user?.mobile ?? 'N/A',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF), fontFamily: "Poppins"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 5. Complete Pricing & Payment Summary ───────────
  Widget _buildPaymentDetails(dynamic b) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF22C55E), size: 18),
              SizedBox(width: 8),
              Text(
                'Payment Summary',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: "Poppins"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow('Base Amount', '₹${b.amount ?? '0'}'),
          if (b.platformCharge != null && double.tryParse(b.platformCharge!) != 0)
            _infoRow('Platform Charge', '₹${b.platformCharge}'),
          _infoRow('GST Amount', '₹${b.gstAmount ?? '0'}'),

          if (b.couponCode != null)
            _infoRow('Coupon (${b.couponCode})', '-₹${b.couponDiscount ?? '0'}', isPrice: true),

          const SizedBox(),
          _infoRow('Total Amount', '₹${b.totalAmount ?? '0'}', isPrice: true),
          const SizedBox(),

          _infoRow('Payment Status', '${b.paymentStatus ?? 'N/A'}'.toUpperCase()),
          _infoRow('Method', '${b.paymentMethod ?? 'N/A'}'.toUpperCase()),
          if (b.codCollected != null)
            _infoRow('COD Collected', '₹${b.codCollected}'),
          if (b.adminDue != null)
            _infoRow('Admin Due', '₹${b.adminDue}'),
        ],
      ),
    );
  }

  // ─── 6. Location Details ─────────────────────────────
  Widget _buildLocationDetails(dynamic b) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on_outlined, color: Color(0xFF22C55E), size: 18),
              SizedBox(width: 8),
              Text(
                'Location Details',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: "Poppins"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_pin, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  b.address ?? 'No address provided',
                  style: const TextStyle(fontSize: 12, fontFamily: "Poppins", color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchGoogleMaps(b.address),
              icon: const Icon(Icons.navigation, size: 16, color: Colors.white),
              label: const Text(
                'Navigate to Location',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins"),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 7. OTP Verification Box ─────────────────────────
  Widget _buildOtpSection() {
    return _card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'OTP Verification',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, fontFamily: "Poppins"),
                ),
                Text(
                  'Enter OTP shared by customer',
                  style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF), fontFamily: "Poppins"),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: List.generate(4, (i) {
              return Container(
                width: 38,
                height: 42,
                margin: EdgeInsets.only(left: i == 0 ? 0 : 6),
                child: TextField(
                  controller: _otpControllers[i],
                  focusNode: _otpFocusNodes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF22C55E), width: 2),
                    ),
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty && i < 3) {
                      _otpFocusNodes[i + 1].requestFocus();
                    } else if (val.isEmpty && i > 0) {
                      _otpFocusNodes[i - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── 8. Bottom Persistent Action Buttons ──────────────
  Widget _buildBottomBar(dynamic b) {
    final orderViewModel = Provider.of<OrderCompleteViewModel>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                String? phoneNumber = b.user?.mobile;

                if (phoneNumber != null && phoneNumber.isNotEmpty) {
                  _makePhoneCall(phoneNumber);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Phone number not available")),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Call',
                style: TextStyle(color: Colors.black, fontFamily: "Poppins", fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: orderViewModel.isLoading
                  ? null
                  : () {
                String otp = _otpControllers.map((c) => c.text).join();

                if (otp.length < 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter full OTP")),
                  );
                  return;
                }

                Map<String, dynamic> data = {
                  "status": "completed",
                  "otp": otp,
                };

                orderViewModel.orderCompleteApi(
                  context: context,
                  id: b.id?.toString(),
                  data: data,
                );
              },
              child: orderViewModel.isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CupertinoActivityIndicator(color: Colors.white),
              )
                  : const Text(
                'Complete Service',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isPrice = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF), fontFamily: "Poppins"),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: "Poppins",
            color: isPrice ? const Color(0xFF22C55E) : Colors.black,
          ),
        ),
      ],
    ),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}