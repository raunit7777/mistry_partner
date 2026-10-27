import 'package:flutter/material.dart';
import 'const_text.dart';

class BookingCard extends StatelessWidget {
  final String title;
  final String discountText;
  final String imagePath; // Ab String path lega
  final List<Color> backgroundGradient;

  const BookingCard({
    super.key,
    required this.title,
    required this.discountText,
    required this.imagePath,
    required this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 154,
      height: 94,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.withOpacity(0.08)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundGradient,
        ),
      ),
      child: Stack(
        children: [
          // Background Asset Image
          Positioned(
            right: -6,
            bottom: -6,
            child: Opacity(
              opacity: 0.9,
              child: SizedBox(
                width: 62,
                height: 62,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain, // 3D icon ke liye best hai
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.bold(
                  title,
                  fontSize: 14.5,
                  color: const Color(0xFF1A1A1A),
                  height: 1.1,
                ),
                const SizedBox(height: 10),
                // Discount Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.12),
                        Colors.white.withOpacity(0.6)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: CustomText.bold(
                    discountText,
                    fontSize: 8.5,
                    color: const Color(0xFF4A90E2),
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}