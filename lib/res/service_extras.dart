// import 'package:flutter/material.dart';
// import '../generated/assets.dart';
// import 'const_text.dart';
//
// class ServiceExtrasSection extends StatelessWidget {
//   const ServiceExtrasSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 1. Does not include Section
//           CustomText.bold("Does not include", fontSize: 20),
//           const SizedBox(height: 16),
//           _buildExcludeItem("Upholstery/appliance interiors, chimneys, or balcony exteriors."),
//           _buildExcludeItem("Heavy grease or stains cleaning, removal of construction debris, and bulk waste."),
//           _buildExcludeItem("Tasks outside the defined package scope and work beyond the booked time."),
//
//           const SizedBox(height: 32),
//
//           // 2. How it's done? Section
//           CustomText.bold("How it's done?", fontSize: 20),
//           const SizedBox(height: 20),
//           _buildStepItem(
//             "Plan the Work",
//             "Your professional plans the tasks as per your needs and time booked.",
//             Assets.assetsCald,
//           ),
//           _buildStepItem(
//             "Start Cleaning",
//             "They'll begin with the tasks you want like sweeping, mopping, or bathroom cleaning.",
//             Assets.assetsTikd,
//           ),
//           _buildStepItem(
//             "Final Checks",
//             "Before finishing, they'll give a quick wipe and make sure everything looks clean and tidy.",
//               Assets.assetsCleand,
//           ),
//
//           const SizedBox(height: 32),
//
//           // 3. FAQs Section
//           CustomText.bold("FAQs", fontSize: 20),
//           const SizedBox(height: 16),
//           _buildFAQItem("What if the cleaning isn't completed within the selected time?"),
//           _buildFAQItem("How can I trust your service?"),
//           _buildFAQItem("Do I need to provide all the cleaning equipment?"),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildExcludeItem(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.cancel, color: Color(0xFFF44336), size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: CustomText.regular(text, fontSize: 12, height: 1.4, color: Colors.black87),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStepItem(String title, String desc, String imgPath) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 24.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 60,
//             width: 60,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF8F9FA),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Image.asset(imgPath, fit: BoxFit.contain),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText.bold(title, fontSize: 14),
//                 const SizedBox(height: 4),
//                 CustomText.regular(desc, fontSize: 12, color: Colors.grey.shade600, height: 1.3),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // FIXED FAQ Item Helper
//   Widget _buildFAQItem(String question) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F9FB),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ExpansionTile(
//         // Divider hatane ke liye Border.none ya empty Border use kiya
//         shape: const RoundedRectangleBorder(side: BorderSide.none),
//         collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
//         title: CustomText.bold(question, fontSize: 12, color: Colors.black87),
//         trailing: const Icon(Icons.add, color: Colors.black87),
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: CustomText.regular("Detailed answer goes here...", fontSize: 12),
//           )
//         ],
//       ),
//     );
//   }
// }