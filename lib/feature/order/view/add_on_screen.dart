import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/addon_view_model.dart'; // Apna sahi path check karein

class ManualAddonScreen extends StatefulWidget {
  final dynamic serviceId; // 🔥 Dynamic ID pass karne ke liye
  const ManualAddonScreen({super.key, required this.serviceId});

  @override
  State<ManualAddonScreen> createState() => _ManualAddonScreenState();
}

class _ManualAddonScreenState extends State<ManualAddonScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final List<Map<String, dynamic>> _manualItems = [];

  void _addItem() {
    if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      setState(() {
        _manualItems.add({
          'name': _nameController.text.trim(),
          'price': _priceController.text.trim(),
        });
        _nameController.clear();
        _priceController.clear();
        FocusScope.of(context).unfocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Add Custom Items",
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 17, color: Colors.black)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          // Input Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: "Item Name", border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                      style: const TextStyle(fontFamily: 'Poppins'),maxLength: 30,
                    ),
                  ),
                  Container(width: 1, height: 30, color: Colors.grey.shade300),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _priceController,
                      decoration: const InputDecoration(hintText: "Price", border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontFamily: 'Poppins'),maxLength: 5,
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.add_circle, color: Color(0xFF22C55E), size: 30), onPressed: _addItem),
                ],
              ),
            ),
          ),

          // List Section
          // List Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _manualItems.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Item Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_manualItems[index]['name'],
                              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                          Text("₹${_manualItems[index]['price']}",
                              style: const TextStyle(fontFamily: 'Poppins', color: Color(0xFF22C55E), fontWeight: FontWeight.w700)),
                        ],
                      ),

                      // 🔥 Subtract/Remove Button
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _manualItems.removeAt(index); // List se item hata diya
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AddonViewModel>(
          builder: (context, addonVM, child) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: addonVM.isLoading || _manualItems.isEmpty
                  ? null
                  : () {
                // Formatting list for API
                List<Map<String, dynamic>> formattedList = _manualItems.map((item) {
                  return {
                    "name": item['name'],
                    "price": int.tryParse(item['price'].toString()) ?? 0,
                  };
                }).toList();

                // Calling ViewModel
                addonVM.sendAddon(context, widget.serviceId, formattedList);
              },
              child: addonVM.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Save All Items", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Colors.white)),
            );
          },
        ),
      ),
    );
  }
}