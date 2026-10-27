import 'package:flutter/material.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText.bold(
          'Terms & Conditions',
          fontSize: 18,
          color: ColorConst.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── CARD 1: Introduction ──
            _buildInfoCard(
              title: "Welcome to Partner Portal",
              content: "By accessing or using our platform, you agree to be bound by these terms. Please read them carefully. These terms govern your relationship with our service network.",
            ),

            const SizedBox(height: 16),

            // ── CARD 2: Detailed Rules ──
            _buildInfoCard(
              title: "Operational Guidelines",
              content: "1. Service Quality: Maintain professional conduct at all times.\n\n"
                  "2. Punctuality: Arrive within the scheduled slot. Notify the customer in case of unavoidable delays.\n\n"
                  "3. Safety: Adhere to all safety protocols provided during onboarding.\n\n"
                  "4. Payment Integrity: Ensure all transactions are processed through the official app portal.",
            ),

            const SizedBox(height: 16),

            // ── CARD 3: Data & Privacy ──
            _buildInfoCard(
              title: "Privacy & Data Policy",
              content: "We value your privacy. Information collected is used solely for operational optimization, service matching, and legal compliance. We do not share your personal identification information with unauthorized third parties.",
            ),

            const SizedBox(height: 32),

            // ── Footer Disclaimer ──
            const Text(
              "Last updated: June 2026",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.bold(
            title,
            fontSize: 16,
            color: ColorConst.green, // Theme ke hisaab se primary color
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 13,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}