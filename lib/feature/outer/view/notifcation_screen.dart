// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:iconly/iconly.dart';
// import '../../../../res/const_color.dart';
// import '../../../../res/const_text.dart';
//
// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//
//   // ── PURE STATIC NOTIFICATION DATA MATRIX ──
//   final List<Map<String, dynamic>> _staticNotifications = [
//     {
//       "id": "notif_1",
//       "title": "New Booking Allocated",
//       "message": "Split AC Deep Jet Cleaning (1.5 Ton) allocated near Hazratganj. Action required.",
//       "timeLabel": "2m",
//       "section": "Today",
//       "isRead": 0,
//       "icon": Icons.ac_unit_rounded,
//       "iconBg": Color(0xFFE8F8F5),
//       "iconColor": Color(0xFF117A65),
//     },
//     {
//       "id": "notif_2",
//       "title": "Payout Disbursed Successfully",
//       "message": "Your weekly earnings of ₹8,450 have been deposited into your verified bank account.",
//       "timeLabel": "1h",
//       "section": "Today",
//       "isRead": 0,
//       "icon": IconlyBold.wallet,
//       "iconBg": Color(0xFFEBF5FB),
//       "iconColor": Color(0xFF2980B9),
//     },
//     {
//       "id": "notif_3",
//       "title": "Job Cancelled by Customer",
//       "message": "Desert Cooler Pump Replacement booking #MS-8842 has been cancelled by the user.",
//       "timeLabel": "Yesterday",
//       "section": "Yesterday",
//       "isRead": 1,
//       "icon": Icons.cancel_rounded,
//       "iconBg": Color(0xFFFADBD8),
//       "iconColor": Colors.red,
//     },
//     {
//       "id": "notif_4",
//       "title": "KYC Documents Verified",
//       "message": "Great news! Your uploaded Aadhaar and Driving License check logs are successfully processed.",
//       "timeLabel": "2d",
//       "section": "Older",
//       "isRead": 1,
//       "icon": IconlyBold.document,
//       "iconBg": Color(0xFFFEF9E7),
//       "iconColor": Color(0xFFFFBF00),
//     }
//   ];
//
//   // Logic to separate notifications according to timeline section keys
//   Map<String, List<Map<String, dynamic>>> _getGroupedNotifications() {
//     final Map<String, List<Map<String, dynamic>>> grouped = {
//       'Today': [],
//       'Yesterday': [],
//       'Older': [],
//     };
//
//     for (var notif in _staticNotifications) {
//       final section = notif['section'] ?? 'Older';
//       if (grouped.containsKey(section)) {
//         grouped[section]!.add(notif);
//       }
//     }
//
//     // Remove empty structural sections
//     grouped.removeWhere((key, value) => value.isEmpty);
//     return grouped;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final groupedMap = _getGroupedNotifications();
//     final sections = groupedMap.entries.toList();
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6F9), // Matching your dashboard background canvas
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         centerTitle: false,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: GestureDetector(
//             onTap: () {
//               HapticFeedback.lightImpact();
//               Navigator.pop(context);
//             },
//             child: Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF3F4F6),
//                 borderRadius: BorderRadius.circular(6), // Sharp rectangular back button box
//               ),
//               child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 12),
//             ),
//           ),
//         ),
//         title: CustomText.bold(
//           'Notifications',
//           fontSize: 18,
//           color: ColorConst.black,
//         ),
//         actions: [
//           // Clear all logs presentation setup
//           TextButton(
//             onPressed: () => HapticFeedback.mediumImpact(),
//             child: Text(
//               "Clear All",
//               style: TextStyle(
//                 fontFamily: "Poppins",
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey.shade500,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: SafeArea(
//         child: sections.isEmpty
//             ? Center(
//           child: CustomText.medium(
//             'No notifications yet',
//             fontSize: 13,
//             color: Colors.grey.shade500,
//           ),
//         )
//             : ListView.builder(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           itemCount: sections.length,
//           itemBuilder: (context, sectionIndex) {
//             final entry = sections[sectionIndex];
//             final label = entry.key;
//             final items = entry.value;
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Section header label group title
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//                   child: CustomText.semiBold(
//                     label,
//                     fontSize: 13,
//                     color: ColorConst.black.withOpacity(0.5),
//                   ),
//                 ),
//
//                 // Notification block rendering cards loop
//                 ...List.generate(items.length, (i) {
//                   final item = items[i];
//                   final isUnread = item["isRead"] == 0;
//
//                   return Dismissible(
//                     key: Key(item["id"]),
//                     direction: DismissDirection.endToStart,
//                     onDismissed: (_) {
//                       HapticFeedback.lightImpact();
//                       setState(() {
//                         _staticNotifications.removeWhere((element) => element["id"] == item["id"]);
//                       });
//                     },
//                     background: Container(
//                       alignment: Alignment.centerRight,
//                       padding: const EdgeInsets.only(right: 20),
//                       margin: const EdgeInsets.symmetric(vertical: 4),
//                       color: Colors.red.shade700,
//                       child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
//                     ),
//                     child: InkWell(
//                       onTap: () {
//                         HapticFeedback.lightImpact();
//                         setState(() {
//                           item["isRead"] = 1; // Interactive toggle state update directly
//                         });
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10), // Sharp Rectangular pattern matching
//                           border: Border.all(color: const Color(0xFFE5E7EB)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.015),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Rectangular Profile/Context Feature Icon Box
//                             Container(
//                               height: 40,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                 color: item["iconBg"],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Icon(item["icon"], color: item["iconColor"], size: 20),
//                             ),
//                             const SizedBox(width: 12),
//
//                             // Core Message parameters text cluster layout block
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Expanded(
//                                         child: CustomText.bold(
//                                           item["title"] ?? '',
//                                           fontSize: 13,
//                                           color: ColorConst.black,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 6),
//                                       Text(
//                                         item["timeLabel"] ?? '',
//                                         style: TextStyle(
//                                           fontFamily: "Poppins",
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.grey.shade400,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 3),
//                                   Text(
//                                     item["message"] ?? '',
//                                     style: TextStyle(
//                                       fontFamily: "Poppins",
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.grey.shade600,
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//
//                             // Unread Active Alert Indicator Dot
//                             if (isUnread)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 4),
//                                 child: Container(
//                                   height: 8,
//                                   width: 8,
//                                   decoration: BoxDecoration(
//                                     color: ColorConst.green, // Uniformed system text theme colors accent
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';
import '../../notification/notification_view_model/notification_view_model.dart';
import '../../notification/notification_view_model/delete_notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // 🔥 Local list taaki UI update immediate ho sake
  List<dynamic> _localNotifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    Provider.of<NotificationViewModel>(context, listen: false).profileApi(context).then((_) {
      // Data aane ke baad local list mein copy karein
      setState(() {
        _localNotifications = Provider.of<NotificationViewModel>(context, listen: false)
            .serviceListData?.data?.notifications ?? [];
      });
    });
  }

  Map<String, List<dynamic>> _getGroupedNotifications(List<dynamic> notifications) {
    final Map<String, List<dynamic>> grouped = {'Today': [], 'Yesterday': [], 'Older': []};
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    for (var notif in notifications) {
      if (notif.createdAt == null) { grouped['Older']!.add(notif); continue; }
      try {
        final parsedDate = DateTime.parse(notif.createdAt.toString()).toLocal();
        final checkDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
        if (checkDate == todayDate) grouped['Today']!.add(notif);
        else if (checkDate == yesterdayDate) grouped['Yesterday']!.add(notif);
        else grouped['Older']!.add(notif);
      } catch (_) { grouped['Older']!.add(notif); }
    }
    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try { return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStr).toLocal()); } catch (_) { return ''; }
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try { return DateFormat('hh:mm a').format(DateTime.parse(dateStr).toLocal()); } catch (_) { return ''; }
  }

  @override
  Widget build(BuildContext context) {
    final notifVM = Provider.of<NotificationViewModel>(context);
    final deleteVM = Provider.of<DeleteNotificationViewModel>(context, listen: false);
    final groupedMap = _getGroupedNotifications(_localNotifications);
    final sections = groupedMap.entries.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 12),
            ),
          ),
        ),
        title: CustomText.bold('Notifications', fontSize: 18, color: ColorConst.black),
      ),
      body: SafeArea(
        child: notifVM.isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _localNotifications.isEmpty
            ? Center(child: CustomText.medium('No notifications yet', fontSize: 13, color: Colors.grey.shade500))
            : ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: sections.length,
          itemBuilder: (context, sectionIndex) {
            final entry = sections[sectionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: CustomText.semiBold(entry.key, fontSize: 13, color: ColorConst.black.withOpacity(0.5)),
                ),
                ...entry.value.map((item) {
                  return Dismissible(
                    key: Key(item.id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      HapticFeedback.lightImpact();
                      // 🔥 Optimistic Update: UI se turant hataya
                      setState(() {
                        _localNotifications.remove(item);
                      });
                      // API Call
                      deleteVM.deleteNotificationApi(context, item.id.toString());
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.red.shade700,
                      child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
                      child: Row(
                        children: [
                          Container(
                            height: 40, width: 40,
                            decoration: BoxDecoration(color: const Color(0xFFE8F8F5), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.notifications_active, color: Color(0xFF117A65), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: CustomText.bold(item.title ?? '', fontSize: 13)),
                                    if (item.createdAt != null)
                                      Text("${_formatDate(item.createdAt)}  ${_formatTime(item.createdAt)}",
                                          style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(item.body ?? '', style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}