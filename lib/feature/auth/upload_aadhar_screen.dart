import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mishtry_partner/feature/auth/view_model/aadhar_update_view_model.dart';
import 'package:provider/provider.dart';

import '../../res/app_btn.dart';
import '../../res/const_color.dart';
import '../../res/const_text.dart';

class AadharUploadScreen extends StatefulWidget {
  const AadharUploadScreen({super.key});

  @override
  State<AadharUploadScreen> createState() => _AadharUploadScreenState();
}

class _AadharUploadScreenState extends State<AadharUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _aadharController = TextEditingController();
  File? frontFile;
  File? backFile;

  Future<void> _pickImage(bool isFront) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: ColorConst.green),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? p = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                if (p != null) setState(() => isFront ? frontFile = File(p.path) : backFile = File(p.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: ColorConst.green),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? p = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                if (p != null) setState(() => isFront ? frontFile = File(p.path) : backFile = File(p.path));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = frontFile != null && backFile != null && _aadharController.text.length == 12;

    return Scaffold(
      backgroundColor: ColorConst.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header & Input Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.bold('Upload Identity Document', fontSize: 24),
                  const Text("Please upload a clear photo of your ID proof"),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _aadharController,
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    onChanged: (val) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Enter 12 digit Aadhaar Number",
                      counterText: "", // Hides the character count below
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Upload Cards Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    _buildUploadCard("Front Side Photo", "Clear photo containing name & photo details", frontFile, () => _pickImage(true)),
                    const SizedBox(height: 20),
                    _buildUploadCard("Back Side Photo", "Clear photo containing address details", backFile, () => _pickImage(false)),
                  ],
                ),
              ),
            ),

            // Submit Button
            Consumer<AadharUpdateViewModel>(
              builder: (context, vm, child) => Padding(
                padding: const EdgeInsets.all(20),
                child: AppBtn(
                  title: vm.isLoading ? 'Uploading...' : 'Submit Verification',
                  color: isButtonEnabled ? ColorConst.green : ColorConst.textGrey1,
                  onTap: isButtonEnabled && !vm.isLoading
                      ? () async {
                    await vm.updateAadhar(
                      context: context,
                      aadharNumber: _aadharController.text,
                      aadharFront: frontFile!,
                      aadharBack: backFile!,
                    );
                  }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard(String title, String subtitle, File? file, VoidCallback onTap) {
    bool hasFile = file != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.semiBold(title, fontSize: 14),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 125,
            width: double.infinity,
            decoration: BoxDecoration(
              color: hasFile ? ColorConst.green.withOpacity(0.04) : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: hasFile ? ColorConst.green : Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(hasFile ? Icons.check_circle : Icons.cloud_upload_outlined,
                    color: hasFile ? ColorConst.green : Colors.grey, size: 32),
                const SizedBox(height: 4),
                Text(hasFile ? "File Selected" : "Upload Photo",
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}