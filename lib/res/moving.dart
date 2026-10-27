// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import '../generated/assets.dart';
//
// class AutoMovingCleaningGrid extends StatefulWidget {
//   const AutoMovingCleaningGrid({super.key});
//
//   @override
//   State<AutoMovingCleaningGrid> createState() =>
//       _AutoMovingCleaningGridState();
// }
//
// class _AutoMovingCleaningGridState
//     extends State<AutoMovingCleaningGrid> {
//   final ScrollController _controller1 = ScrollController();
//   final ScrollController _controller2 = ScrollController();
//   final ScrollController _controller3 = ScrollController();
//
//   Timer? _timer;
//
//   final List<Map<String, String>> _cleaningItems = [
//     {'image': Assets.assets31, 'label': 'Sweeping'},
//     {'image': Assets.assets32, 'label': 'Sink Clean'},
//     {'image': Assets.assets33, 'label': 'Toilet'},
//     {'image': Assets.assets34, 'label': 'Mopping'},
//     {'image': Assets.assets35, 'label': 'Dusting'},
//     {'image': Assets.assets36, 'label': 'Kitchen'},
//     {'image': Assets.assets37, 'label': 'Laundry'},
//     {'image': Assets.assets38, 'label': 'Fan Clean'},
//     {'image': Assets.assets39, 'label': 'Polish'},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startAutoScroll();
//     });
//   }
//
//   void _startAutoScroll() {
//     double offset1 = 0;
//     double offset2 = 0;
//     double offset3 = 0;
//
//     _timer = Timer.periodic(
//       const Duration(milliseconds: 40),
//           (timer) {
//         // Row 1
//         if (_controller1.hasClients) {
//           offset1 += 0.5;
//
//           if (offset1 >=
//               _controller1.position.maxScrollExtent) {
//             offset1 = 0;
//           }
//
//           _controller1.jumpTo(offset1);
//         }
//
//         // Row 2 (Opposite Direction)
//         if (_controller2.hasClients) {
//           offset2 -= 0.5;
//
//           if (offset2 <= 0) {
//             offset2 =
//                 _controller2.position.maxScrollExtent;
//           }
//
//           _controller2.jumpTo(offset2);
//         }
//
//         // Row 3
//         if (_controller3.hasClients) {
//           offset3 += 0.5;
//
//           if (offset3 >=
//               _controller3.position.maxScrollExtent) {
//             offset3 = 0;
//           }
//
//           _controller3.jumpTo(offset3);
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//
//     _controller1.dispose();
//     _controller2.dispose();
//     _controller3.dispose();
//
//     super.dispose();
//   }
//
//   Widget buildRow(
//       ScrollController controller,
//       List<Map<String, String>> items,
//       ) {
//     return SizedBox(
//       height: 80,
//       child: ListView.builder(
//         controller: controller,
//         scrollDirection: Axis.horizontal,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: items.length * 10,
//         itemBuilder: (context, index) {
//           final item = items[index % items.length];
//
//           return Container(
//             width: 85,
//             margin: const EdgeInsets.only(right: 8),
//             clipBehavior: Clip.antiAlias,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF5F5F5),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Image.asset(
//               item['image'] ?? '',
//               fit: BoxFit.cover,
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         buildRow(
//           _controller1,
//           _cleaningItems.sublist(0, 3),
//         ),
//
//         const SizedBox(height: 12),
//
//         buildRow(
//           _controller2,
//           _cleaningItems.sublist(3, 6),
//         ),
//
//         const SizedBox(height: 12),
//
//         buildRow(
//           _controller3,
//           _cleaningItems.sublist(6, 9),
//         ),
//
//
//
//       ],
//     );
//   }
// }