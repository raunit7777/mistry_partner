import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../res/app_btn.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';
import '../../../res/aap_urls.dart';
import '../../auth/view_model/profile_view_model.dart';
import '../view_model/profile_update_view_model.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _existingImageUrl;
  @override
  String fromScreen = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Receive argument
      fromScreen = ModalRoute.of(context)?.settings.arguments as String? ?? "";

      print("Argument: $fromScreen");

      final vm = Provider.of<ProfileViewModel>(
        context,
        listen: false,
      ).serviceListData?.data?.worker;

      if (vm != null) {
        _nameController.text = vm.name ?? "";
        _emailController.text = vm.email ?? "";

        setState(() {
          _existingImageUrl = vm.profileImage;
        });
      }
    });
  }

  // Camera + Gallery Logic
  Future<void> _pickImage() async {
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
                if (p != null) setState(() => _imageFile = File(p.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: ColorConst.green),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? p = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                if (p != null) setState(() => _imageFile = File(p.path));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context, listen: false).serviceListData?.data?.worker;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: CustomText.bold("Edit Profile", fontSize: 18, color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage, // Bottom sheet open hoga
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)]),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade100,
                        // Logic: Agar user ne nayi file select ki hai toh wo dikhe, nahi toh network image
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
                            ? NetworkImage("${AppUrl.baseUrlImg}/$_existingImageUrl") as ImageProvider
                            : null,
                        child: (_imageFile == null && (_existingImageUrl == null || _existingImageUrl!.isEmpty))
                            ? const Icon(IconlyBold.camera, size: 40, color: ColorConst.green)
                            : null,
                      ),
                    ),
                    Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: ColorConst.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)), child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Full Name"),
                  _buildInputField(_nameController, "Enter your name", IconlyLight.profile),
                  const SizedBox(height: 20),
                  _buildLabel("Email Address"),
                  _buildInputField(_emailController, "Enter your email", IconlyLight.message, keyboardType: TextInputType.emailAddress),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<ProfileUpdateViewModel>(
        builder: (context, vm, child) => Padding(
          padding: const EdgeInsets.all(20),
          child: AppBtn(
            title: vm.isLoading ? "Saving Changes..." : "Save Changes",
            color: ColorConst.green,
            onTap: vm.isLoading ? null : () async {
              await vm.profileUpdate(context: context, name: _nameController.text, email: _emailController.text, image: _imageFile, nav: fromScreen);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(text, style: const TextStyle(fontFamily: "Poppins", fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)));

  Widget _buildInputField(TextEditingController controller, String hint, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: ColorConst.green, size: 22), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18)),
      ),
    );
  }
}