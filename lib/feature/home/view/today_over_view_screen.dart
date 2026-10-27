import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';
import '../view_model/view_model_gg.dart';

class TodayOverviewScreen extends StatefulWidget {
  const TodayOverviewScreen({super.key});

  @override
  State<TodayOverviewScreen> createState() => _TodayOverviewScreenState();
}

class _TodayOverviewScreenState extends State<TodayOverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViewModelGg>(context, listen: false).overViewApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context)),
        title: CustomText.bold('Overview', fontSize: 18, color: ColorConst.black),
      ),
      body: Consumer<ViewModelGg>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.serviceListData == null) {
            return const Center(child: CircularProgressIndicator(color: ColorConst.green));
          }

          final stats = vm.serviceListData?.data?.stats;

          return RefreshIndicator(
            color: ColorConst.green,
            onRefresh: () async {
              await Provider.of<ViewModelGg>(context, listen: false).overViewApi(context);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. EARNINGS SUMMARY SECTION ──
                  _buildSectionHeader("Earnings Summary"),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00A36C), Color(0xFF117A65)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Earnings", style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: "Poppins")),
                        Text("₹${stats?.totalEarning ?? 0}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: "Poppins")),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white24, height: 1)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildWalletSubStat("Cash Collected", "₹${stats?.cashCollected ?? 0}"),
                            _buildVerticalDivider(),
                            _buildWalletSubStat("Online Paid", "₹${stats?.onlinePaid ?? 0}"),
                            _buildVerticalDivider(),
                            _buildWalletSubStat("Net Earning", "₹${stats?.netEarning ?? 0}"),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── 2. JOB SUMMARY GRID ──
                  _buildSectionHeader("Job Summary"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildJobSquareCard("Total", "${stats?.totalAssigned ?? 0}", IconlyBold.work, const Color(0xFF2471A3), const Color(0xFFEBF5FB))),
                      const SizedBox(width: 8),
                      Expanded(child: _buildJobSquareCard("Done", "${stats?.jobsCompleted ?? 0}", Icons.check_circle, ColorConst.green, const Color(0xFFE8F8F5))),
                      const SizedBox(width: 8),
                      Expanded(child: _buildJobSquareCard("Pending", "${stats?.inProgress ?? 0}", Icons.watch_later, const Color(0xFFFFBF00), const Color(0xFFFEF9E7))),
                      const SizedBox(width: 8),
                      Expanded(child: _buildJobSquareCard("Cancel", "${stats?.cancelled ?? 0}", Icons.cancel, Colors.red, const Color(0xFFFADBD8))),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── 3. PERFORMANCE MATRIX SECTION ──
                  _buildSectionHeader("Performance Metrics"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPerformanceRowCard(
                          title: "Customer Rating",
                          value: "${stats?.rating ?? 0.0}",
                          badgeText: "${stats?.ratingCount ?? 0} Votes",
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFFFBF00),
                          iconBg: const Color(0xFFFEF9E7),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildPerformanceRowCard(
                          title: "Acceptance Rate",
                          value: "${stats?.acceptanceRate ?? 0}%",
                          badgeText: "Live Rate",
                          icon: Icons.thumb_up_alt_rounded,
                          iconColor: const Color(0xFF00A36C),
                          iconBg: const Color(0xFFE8F8F5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── 4. LEDGER & PLATFORM FEES SUMMARY ──
                  _buildSectionHeader("Payout & Fees Ledger"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildLedgerRow("Current Wallet Balance", "₹${stats?.wallet ?? 0}", Icons.account_balance_wallet_outlined, Colors.blue),
                        const Divider(height: 24),
                        _buildLedgerRow("Platform Fees Deducted", "₹${stats?.platformFees ?? 0}", Icons.hub_outlined, Colors.purple),
                        const Divider(height: 24),
                        _buildLedgerRow("Admin Outstanding Due", "₹${stats?.adminDue ?? 0}", Icons.gavel_rounded, Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildSectionHeader(String title) => Text(
    title,
    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
  );

  Widget _buildWalletSubStat(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: "Poppins")),
      const SizedBox(height: 2),
      Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: "Poppins")),
    ],
  );

  Widget _buildJobSquareCard(String title, String value, IconData icon, Color accent, Color bg) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: accent, size: 16),
        ),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontFamily: "Poppins")),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accent, fontFamily: "Poppins")),
      ],
    ),
  );

  Widget _buildPerformanceRowCard({
    required String title,
    required String value,
    required String badgeText,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontFamily: "Poppins")),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "Poppins")),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(4)),
                        child: Text(badgeText, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: iconColor, fontFamily: "Poppins")),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );

  Widget _buildLedgerRow(String label, String value, IconData icon, Color iconColor) => Row(
    children: [
      CircleAvatar(
        radius: 16,
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, size: 16, color: iconColor),
      ),
      const SizedBox(width: 10),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontFamily: "Poppins")),
      const Spacer(),
      Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "Poppins")),
    ],
  );

  Widget _buildVerticalDivider() => Container(width: 1, height: 22, color: Colors.white24);
}