import 'package:flutter/material.dart';
import 'const_text.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Overall border radius
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section with Top Rounding
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), // Image ko upar se round karega
              child: Container(
                height: 70,
                width: double.infinity,
                color: const Color(0xFFF8F9FA),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: CustomText.bold(
                title,
                fontSize: 10.5,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}