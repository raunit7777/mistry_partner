import 'dart:async';
import 'package:flutter/material.dart';
import '../../../main.dart'; // height access karne ke liye

class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({Key? key}) : super(key: key);

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  Timer? _timer;

  // 🔥 Hardcoded Local Assets Banners Ki List
  // Apne pubspec.yaml ke hisaab se yahan images ke sahi naam daal dena
  final List<String> localBanners = [
    'assets/spl.png',
    'assets/spl.png',
    'assets/spl.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;

      if (localBanners.isEmpty) return;

      if (currentIndex < localBanners.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Agar list empty ho toh safe border box dikhane ke liye
    if (localBanners.isEmpty) {
      return Container(
        height: height * 0.54, // Aap apne convenience ke hisaab se height adjust kar sakte hain
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text("No Banners Found", style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return SizedBox(
      height: height * 0.55, // Pure screen par fit baithne ke liye 0.22 ya 0.25 use kar sakte ho
      child: PageView.builder(
        controller: _pageController,
        itemCount: localBanners.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            // Dono side se thoda premium gap
            decoration: BoxDecoration(

              color: const Color(0xFFF2F5F5),
            ),
            child: ClipRRect(
         // Image ke corners smooth karne ke liye
              child: Image.asset(
                localBanners[index],
                fit: BoxFit.cover, // Poori space cover karega bina squeeze hue
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}