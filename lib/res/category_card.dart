// import 'package:flutter/material.dart';
// import 'package:mishtry/feature/category/booking_screen.dart';
// import '../main.dart';
// import 'const_text.dart';
//
// class ServiceCard extends StatelessWidget {
//   final String imageUrl;
//   final String rating;
//   final String reviewCount;
//   final String title;
//   final String price;
//   final String originalPrice;
//
//   const ServiceCard({
//     super.key,
//     required this.imageUrl,
//     required this.rating,
//     required this.reviewCount,
//     required this.title,
//     required this.price,
//     required this.originalPrice,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150, // Width ko 120 se 150 kiya card ko "long" karne ke liye
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               // Image Container - Height ko 80 se 100 kiya balance ke liye
//               Container(padding: EdgeInsets.only(top: 20),
//                 height: 100,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFF2F5F5),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//
//               // Rating Badge
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(20),
//                       bottomLeft: Radius.circular(12),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.star, color: Colors.orangeAccent, size: 12),
//                       const SizedBox(width: 3),
//                       CustomText.bold("$rating", fontSize: 10, color: Colors.grey.shade800),
//                       CustomText.regular(" ($reviewCount)", fontSize: 8, color: Colors.grey),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // Content Section
//           Padding(
//             padding: const EdgeInsets.all(12.0), // Padding thoda badhaya space ke liye
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText.bold(
//                   title,
//                   fontSize: 12, // Font thoda bada kiya long card ke hisaab se
//                   height: 1.2,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     CustomText.bold("₹$price", fontSize: 14),
//                     const SizedBox(width: 6),
//                     CustomText.regular(
//                       "₹$originalPrice",
//                       fontSize: 10,
//                       color: Colors.grey,
//                       showLineThrough: true,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }