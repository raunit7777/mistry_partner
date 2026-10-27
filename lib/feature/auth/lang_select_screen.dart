import 'package:flutter/material.dart';

import 'otp_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // Selected language ko track karne ke liye variable
  int selectedIndex = 0;

  // Language Data Model
  final List<Map<String, String>> languages = [
    {'native': 'English', 'sub': 'English', 'letter': 'A'},
    {'native': 'हिन्दी', 'sub': 'Hindi', 'letter': 'अ'},
    {'native': 'বাংলা', 'sub': 'Bengali', 'letter': 'বা'},
    {'native': 'தமிழ்', 'sub': 'Tamil', 'letter': 'த'},
    {'native': 'తెలుగు', 'sub': 'Telugu', 'letter': 'తె'},
    {'native': 'ಕನ್ನಡ', 'sub': 'Kannada', 'letter': 'ಅ'},
  ];

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: const Color(0xFF073B24), // Top dark green gradient mix background
      body: Stack(
        children: [
          // 1. BACKGROUND HERO BANNER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child:Image.asset(
              'assets/bn.png', // Apni image ka asset path yahan dalein
              fit: BoxFit.contain,
            ),
          ),

          // 2. BOTTOM LANGUAGE SHEET
          Positioned(
            top: screenHeight * 0.36, // Chhota panel overlap dene ke liye
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading
                  const Text(
                    'Select a language',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Languages Grid Structure using Wrap for better flexibility
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Wrap(
                        spacing: 14, // Horizontal space between cards
                        runSpacing: 14, // Vertical space between rows
                        children: List.generate(languages.length, (index) {
                          final bool isSelected = selectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              // Screen ki width ke hisaab se 2 column grid adjust karne ka standard formula
                              width: (screenWidth - 54) / 2,
                              height: 85,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF0CAF68) : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Main Language Text
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        languages[index]['native']!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? const Color(0xFF0CAF68) : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        languages[index]['sub']!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Faded Watermark Character on Right End
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    top: 0,
                                    child: Center(
                                      child: Text(
                                        languages[index]['letter']!,
                                        style: TextStyle(
                                          fontSize: 38,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? const Color(0xFF0CAF68).withOpacity(0.12)
                                              : Colors.blueGrey.shade100.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  // 3. CONTINUE BUTTON
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action on Continue click
                          debugPrint("Selected Language: ${languages[selectedIndex]['sub']}");
                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const OtpVerificationScreen(mobileNumber: '99999999999',)),
                          //       (route) => false, // Saari back screens remove kar dega dashboard par
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0CAF68), // Fresh Green color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}