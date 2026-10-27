import 'package:flutter/material.dart';

import '../../res/app_btn.dart';
import '../../res/const_color.dart';
import '../../res/const_text.dart';


class InternetChecker extends StatelessWidget {
  const InternetChecker({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen height ke liye MediaQuery
    final double screenHeight = MediaQuery.of(context).size.height;

    return Positioned.fill(
      child: Material(
        color: ColorConst.white,
        child:  Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/no-connection.gif"),


              // Title using CustomText.bold
              CustomText.bold(
                "No Internet Connection",
                textAlign: TextAlign.center,
                fontSize: 22,
                color: ColorConst.primaryGreen,
              ),

              const SizedBox(height: 12),

              // Description using CustomText.regular
              CustomText.regular(
                "Try switching to a different connection or reset your internet to place an order.",
                color: ColorConst.primaryGreen,
                textAlign: TextAlign.center,
                fontSize: 14,
                height: 1.5, // Thoda gap lines ke beech
              ),

              const SizedBox(height: 40),

              // Action Button
              AppBtn(
                title: "Try Again",
                onTap: () {
                  // Refresh logic yahan aayegi
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}