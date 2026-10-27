import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mishtry_partner/feature/auth/select_city_screen.dart';
import 'package:mishtry_partner/feature/auth/view_model/login_view_mode.dart';
import 'package:mishtry_partner/feature/auth/view_model/verify_otp_view_model.dart';
import 'package:provider/provider.dart';
import '../../confic/utils/routes/routes_name.dart';
import '../../res/app_btn.dart';
import '../../res/banner.dart';
import '../../res/const_color.dart';
import '../../res/const_text.dart';



class OtpVerificationScreen extends StatefulWidget {


  const OtpVerificationScreen({super.key, });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());


  int _resendSeconds = 30;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _resendSeconds = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        setState(() {
          _canResend = true;
          _timer?.cancel();
        });
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // OTP complete hua ya nahi check karne ka logic
  bool _isOtpComplete() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }


  String _getOtpString() {
    return _controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isButtonEnabled = _isOtpComplete();
final vm = Provider.of<LoginViewModel>(context,listen: false);
    return Scaffold(
      backgroundColor: ColorConst.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [

          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SafeArea(
                  bottom: false,
                  child: SizedBox(height: 0),
                ),
                const HomeBannerSlider(),
              ],
            ),
          ),

          // ── BACK BUTTON ──



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
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Heading Title
                        CustomText.bold(
                          'OTP Verification',
                          fontSize: 22,
                          color: ColorConst.black,
                        ),
                        const SizedBox(height: 8),

                        // Subtitle with mobile number
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Screen ke center mein dikhane ke liye
                          children: [
                            // 1. Message Text
                            CustomText.regular(
                              'An OTP has been sent to +91${vm.mobile.text} ',
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              textAlign: TextAlign.center,
                            ),

                            // 2. Edit Action
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, RoutesName.loginScreen);

                                // Ya agar LoginScreen par push karna hai toh:
                                // Navigator.pushNamed(context, '/login_screen');
                              },
                              child: CustomText.bold( // bold ya regular jo aap use karte hain
                                "Edit",
                                fontSize: 13,
                                color: Colors.blue, // Edit button ka color blue rakha hai taaki alag dikhe
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ── 4 DIGITS NATIVE PIN INPUTS BLOCK ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return SizedBox(
                              width: 56,
                              height: 56,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                textInputAction: index == 3 ? TextInputAction.done : TextInputAction.next,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  color: Colors.black,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  fillColor: Colors.white.withOpacity(0.9),
                                  filled: true,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: ColorConst.green, width: 2),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    // Agle box par focus shift karo
                                    if (index < 3) {
                                      _focusNodes[index + 1].requestFocus();
                                    } else {
                                      _focusNodes[index].unfocus(); // Last digit par keyboard close
                                    }
                                  } else {
                                    // Backspace dabane par piche wale box par focus shift karo
                                    if (index > 0) {
                                      _focusNodes[index - 1].requestFocus();
                                    }
                                  }
                                  setState(() {}); // Button state color refresh handler
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),

                        // ── RESEND TIMER SECTION ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: TextStyle(fontSize: 13, fontFamily: "Poppins", color: Colors.grey.shade600),
                            ),
                            _canResend
                                ? GestureDetector(
                              onTap: () {
                                _startTimer();
                                // 🔥 Yahan apna Resend OTP API call bind kar sakte ho
                              },
                              child: const Text(
                                "Resend",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: ColorConst.green,
                                ),
                              ),
                            )
                                : Text(
                              "Resend in 0:${_resendSeconds < 10 ? '0' : ''}$_resendSeconds",
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: ColorConst.orange, // Timer ke liye orange contrast accent use kiya h
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // ── VERIFY CONTINUE BUTTON ──
                        // Consumer ko import karein aur AppBtn ke andar ye logic lagayein
                        // Consumer wrap karein taaki loading state update ho sake
                        Consumer<VerifyOtpViewModel>(
                          builder: (context, otpVM, child) {
                            return AppBtn(
                              title: otpVM.isLoading ? 'Verifying...' : 'Verify & Proceed',
                              loading: otpVM.isLoading, // Yaha loading state pass ho raha hai
                              width: screenWidth - 40,
                              color: (isButtonEnabled && !otpVM.isLoading)
                                  ? ColorConst.green
                                  : ColorConst.textGrey1,
                              borderRadius: 14,
                              onTap: (isButtonEnabled && !otpVM.isLoading)
                                  ? () {
                                FocusScope.of(context).unfocus();
                                otpVM.otp.text = _getOtpString();
                                otpVM.verifyOtp(context);
                              }
                                  : null,
                            );
                          },
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
  }
}