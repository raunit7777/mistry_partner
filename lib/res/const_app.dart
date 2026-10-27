// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';
// import 'const_text.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final List<Widget>? actions;
//   final VoidCallback? onBackPress;
//   final bool showBackButton;
//
//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.actions,
//     this.onBackPress,
//     this.showBackButton = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       // Scroll hone par color change rokne ke liye ye 2 lines zaroori hain:
//       surfaceTintColor: Colors.transparent,
//       scrolledUnderElevation: 0,
//
//       elevation: 0,
//       centerTitle: false,
//       leading: showBackButton
//           ? IconButton(
//         onPressed: onBackPress ?? () => Navigator.pop(context),
//         icon: const Icon(IconlyLight.arrow_left, color: Colors.black, size: 20),
//       )
//           : null,
//       automaticallyImplyLeading: false,
//       titleSpacing: showBackButton ? 0 : 20,
//       title: CustomText.semiBold(
//         title,
//         fontSize: 16,
//         color: Colors.black,
//       ),
//       actions: actions,
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }