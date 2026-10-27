import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mishtry_partner/feature/auth/view_model/login_view_mode.dart';
import 'package:provider/provider.dart';

import '../../res/app_btn.dart';
import '../../res/banner.dart';
import '../../res/const_color.dart';
import '../../res/const_text.dart';
import '../../res/custom_text_feild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;


    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {

        bool isButtonEnabled = viewModel.mobile.text.length == 10;

        return Scaffold(
          backgroundColor: ColorConst.white,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [

              const Positioned.fill(
                child: HomeBannerSlider(),
              ),


              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5)),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText.bold('Log in or Sign up', fontSize: 22, color: ColorConst.black),
                            const SizedBox(height: 16),

                            // Phone field
                            CustomTextField(
                              controller: viewModel.mobile,
                              hintText: 'Enter mobile number',
                              keyboardType: TextInputType.phone,
                              fillColor: Colors.white.withOpacity(0.9),
                              width: screenWidth - 40,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp(r'^[6-9][0-9]*$')),
                              ],
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                child: CustomText.semiBold('+91', fontSize: 15, color: ColorConst.black),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 12),

                            // Continue button
                            AppBtn(
                              title: viewModel.isLoading ? 'Processing...' : 'Continue',
                              width: screenWidth - 40,
                              color: isButtonEnabled ? ColorConst.green : ColorConst.textGrey1,
                              borderRadius: 14,
                              onTap: (isButtonEnabled && !viewModel.isLoading)
                                  ? () {
                                viewModel.login(context, 0);
                                FocusScope.of(context).unfocus();
                              }
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            // Terms
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(fontFamily: "Poppins", fontSize: 11, color: Colors.grey),
                                children: [
                                  const TextSpan(text: 'By continuing, you agree to our '),
                                  WidgetSpan(child: CustomText.medium('Terms of Service', fontSize: 10, color: ColorConst.black, showUnderline: true)),
                                  const TextSpan(text: ' & '),
                                  WidgetSpan(child: CustomText.medium('Privacy Policy', fontSize: 10, color: ColorConst.black, showUnderline: true)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}