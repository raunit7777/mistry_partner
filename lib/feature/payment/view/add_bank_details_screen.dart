 // import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../../../res/const_color.dart';
// import '../../../../res/const_text.dart';
//
// class BankDetailsScreen extends StatefulWidget {
//   const BankDetailsScreen({super.key});
//
//   @override
//   State<BankDetailsScreen> createState() => _BankDetailsScreenState();
// }
//
// class _BankDetailsScreenState extends State<BankDetailsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _bankNameController = TextEditingController();
//   final _accHolderController = TextEditingController();
//   final _accNumberController = TextEditingController();
//   final _ifscController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F9F9),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: CustomText.bold('Add Bank Details', fontSize: 17),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildInputField(label: "Bank Name", controller: _bankNameController, hint: "e.g. State Bank of India"),
//               _buildInputField(label: "Account Holder Name", controller: _accHolderController, hint: "As per bank record"),
//               _buildInputField(label: "Account Number", controller: _accNumberController, hint: "Enter account number", isNumeric: true),
//               _buildInputField(label: "IFSC Code", controller: _ifscController, hint: "e.g. SBIN0001234"),
//
//               const SizedBox(height: 32),
//
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorConst.green,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       // Yahan API call karein
//                     }
//                   },
//                   child: const Text("Save Bank Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputField({
//     required String label,
//     required TextEditingController controller,
//     required String hint,
//     bool isNumeric = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: controller,
//             keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
//             inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
//               filled: true,
//               fillColor: Colors.white,
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             ),
//             validator: (value) => value!.isEmpty ? "This field is required" : null,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import '../../../../res/const_color.dart';
import '../../../../res/const_text.dart';
import '../../../res/app_btn.dart';
import '../../../res/custom_text_feild.dart';
import '../view_model/add_bank_view_model.dart';
import '../view_model/get_details_view_model.dart'; // Apna sahi path check karein

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accHolderController = TextEditingController();
  final _accNumberController = TextEditingController();
  final _ifscController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetDetailsViewModel>(context, listen: false).profileApi(context).then((_) {
        _fillData();
      });
    });
  }

  void _fillData() {
    final data = Provider.of<GetDetailsViewModel>(context, listen: false).serviceListData?.data;
    if (data != null) {
      _bankNameController.text = data.bankName ?? "";
      _accHolderController.text = data.holderName ?? "";
      _accNumberController.text = data.accountNumber ?? "";
      _ifscController.text = data.ifscCode ?? "";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GetDetailsViewModel>(context);
    final data = vm.serviceListData?.data;
    bool hasData = data != null && (data.bankName?.isNotEmpty ?? false);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText.bold(hasData && !isEditing ? 'Bank Details' : 'Add Bank Details', fontSize: 17),
        actions: [
          if (hasData && !isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: ColorConst.green),
              onPressed: () => setState(() => isEditing = true),
            )
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: (hasData && !isEditing)
            ? _buildViewMode(data)
            : _buildFormMode(),
      ),
    );
  }

  // --- View Mode ---
// --- View Mode (Bank Card Style) ---
  Widget _buildViewMode(data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorConst.green, ColorConst.green.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: ColorConst.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("BANK ACCOUNT", style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold,fontFamily: "Poppins")),
          const SizedBox(height: 15),
          Text(data.bankName ?? "---", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,fontFamily: "Poppins")),
          const SizedBox(height: 20),
          _detailRow("Holder Name", data.holderName ?? "---"),
          const SizedBox(height: 10),
          _detailRow("Account Number", data.accountNumber ?? "---"),
          const SizedBox(height: 10),
          _detailRow("IFSC Code", data.ifscCode ?? "---"),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildFormMode() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Wrapper Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernField(
                  label: "Bank Name",
                  controller: _bankNameController,
                  hint: "State Bank of India",
                  icon: IconlyLight.home, // Changed to Iconly
                ),
                _buildModernField(
                  label: "Account Holder Name",
                  controller: _accHolderController,
                  hint: "Full Name",
                  icon: IconlyLight.profile, // Changed to Iconly
                ),
                _buildModernField(
                  label: "Account Number",
                  controller: _accNumberController,
                  hint: "1234567890",
                  isNumeric: true,
                  icon: IconlyLight.wallet, // Changed to Iconly
                  validator: (val) => (val!.length < 9) ? "Enter valid number" : null,
                ),
                _buildModernField(
                  label: "IFSC Code",
                  controller: _ifscController,
                  hint: "SBIN0001234",
                  isIFSC: true,
                  icon: IconlyLight.document, // Changed to Iconly
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Save Button
          Consumer<AddBankViewModel>(
            builder: (context, addBankVM, child) {
              return AppBtn(
                title: "SAVE DETAILS",
                loading: addBankVM.isLoading, // 🔥 Aapka AppBtn loading handle kar lega
                height: 55,
                borderRadius: 15,
                color: ColorConst.green,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    addBankVM.addBankDetails(
                      context: context,
                      bankName: _bankNameController.text.trim(),
                      holderName: _accHolderController.text.trim(),
                      accountNumber: _accNumberController.text.trim(),
                      ifscCode: _ifscController.text.trim(),
                      nav: "1",
                    ).then((_) => setState(() => isEditing = false));
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

// Updated Modern Helper Widget
  Widget _buildModernField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon, // Updated to IconData
    bool isNumeric = false,
    bool isIFSC = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF4A4A4A))),
          ),
          CustomTextField(
            controller: controller,
            hintText: hint,
            prefixIcon: Icon(icon, color: ColorConst.green, size: 22),
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
            textCapitalization: isIFSC ? TextCapitalization.characters : TextCapitalization.words,
            validator: validator ?? (val) => val!.isEmpty ? "$label is required" : null,
            fieldRadius: BorderRadius.circular(16),
            fillColor: Colors.white,
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String label, String? value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isNumeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: (value) => value!.isEmpty ? "This field is required" : null,
          ),
        ],
      ),
    );
  }
}