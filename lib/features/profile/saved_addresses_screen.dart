import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  static const Color primary = Color(0xFF995037);
  static const Color cream = Color(0xFFFBF8F1);
  static const Color brown = Color(0xFF341F15);
  static const Color muted = Color(0xFF81766D);

  List<Map<String, dynamic>> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('dum_yani_addresses');

      List<Map<String, dynamic>> loaded = [];

      if (saved != null) {
        final List decoded = jsonDecode(saved);

        loaded = decoded
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }

      if (!mounted) return;

      setState(() {
        addresses = loaded;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load saved addresses.')),
      );
    }
  }

  Future<void> saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('dum_yani_addresses', jsonEncode(addresses));
  }

  Future<void> showAddressForm({int? index}) async {
    final existing = index != null ? addresses[index] : null;

    final nameController = TextEditingController(text: existing?['name'] ?? '');
    final phoneController = TextEditingController(
      text: existing?['phone'] ?? '',
    );
    final houseController = TextEditingController(
      text: existing?['house'] ?? '',
    );
    final areaController = TextEditingController(text: existing?['area'] ?? '');
    final cityController = TextEditingController(text: existing?['city'] ?? '');
    final pincodeController = TextEditingController(
      text: existing?['pincode'] ?? '',
    );

    String type = existing?['type'] ?? 'Home';

    try {
      final result = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: cream,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (sheetContext) {
          return StatefulBuilder(
            builder: (context, setSheetState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        index == null ? 'Add New Address' : 'Edit Address',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: brown,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _field(nameController, 'Full Name'),

                      _field(
                        phoneController,
                        'Mobile Number',
                        keyboard: TextInputType.phone,
                      ),

                      _field(houseController, 'House / Flat / Building'),

                      _field(areaController, 'Area / Street / Landmark'),

                      _field(cityController, 'City'),

                      _field(
                        pincodeController,
                        'PIN Code',
                        keyboard: TextInputType.number,
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Address Type',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: brown,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        children: ['Home', 'Work', 'Other'].map((item) {
                          return ChoiceChip(
                            label: Text(item),
                            selected: type == item,
                            selectedColor: primary.withValues(alpha: 0.18),
                            onSelected: (_) {
                              setSheetState(() {
                                type = item;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            if (nameController.text.trim().isEmpty ||
                                phoneController.text.trim().isEmpty ||
                                houseController.text.trim().isEmpty ||
                                areaController.text.trim().isEmpty ||
                                cityController.text.trim().isEmpty ||
                                pincodeController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(sheetContext).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in all fields'),
                                ),
                              );
                              return;
                            }

                            final address = <String, dynamic>{
                              'name': nameController.text.trim(),
                              'phone': phoneController.text.trim(),
                              'house': houseController.text.trim(),
                              'area': areaController.text.trim(),
                              'city': cityController.text.trim(),
                              'pincode': pincodeController.text.trim(),
                              'type': type,
                              'isDefault':
                                  existing?['isDefault'] ?? addresses.isEmpty,
                            };

                            // Close the bottom sheet and return the new address.
                            Navigator.pop(sheetContext, address);
                          },
                          child: Text(
                            index == null ? 'Save Address' : 'Update Address',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );

      // Update the address list only after the bottom sheet has closed.
      if (result != null && mounted) {
        setState(() {
          if (index == null) {
            addresses.add(result);
          } else if (index < addresses.length) {
            addresses[index] = result;
          }
        });

        await saveAddresses();
      }
    } finally {
      nameController.dispose();
      phoneController.dispose();
      houseController.dispose();
      areaController.dispose();
      cityController.dispose();
      pincodeController.dispose();
    }
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> setDefault(int index) async {
    setState(() {
      for (int i = 0; i < addresses.length; i++) {
        addresses[i]['isDefault'] = i == index;
      }
    });

    await saveAddresses();
  }

  Future<void> deleteAddress(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Address?'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() {
        addresses.removeAt(index);

        if (addresses.isNotEmpty &&
            !addresses.any((address) => address['isDefault'] == true)) {
          addresses.first['isDefault'] = true;
        }
      });

      await saveAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        foregroundColor: brown,
        elevation: 0,
        title: const Text(
          'Saved Addresses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? _emptyState()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Your delivery locations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: brown,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Manage the places where you love receiving Dum Yani.',
                  style: TextStyle(color: muted),
                ),

                const SizedBox(height: 20),

                ...List.generate(addresses.length, (index) {
                  final address = addresses[index];
                  final isDefault = address['isDefault'] == true;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDefault ? primary : const Color(0xFFE8DED2),
                        width: isDefault ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              address['type'] == 'Work'
                                  ? Icons.work_outline
                                  : address['type'] == 'Home'
                                  ? Icons.home_outlined
                                  : Icons.location_on_outlined,
                              color: primary,
                            ),

                            const SizedBox(width: 10),

                            Text(
                              address['type'] ?? 'Other',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: brown,
                              ),
                            ),

                            const Spacer(),

                            if (isDefault)
                              const Chip(
                                label: Text('DEFAULT'),
                                backgroundColor: Color(0xFFF3E7DE),
                                labelStyle: TextStyle(
                                  color: primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text(
                          address['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: brown,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '${address['house']}, ${address['area']}, '
                          '${address['city']} - ${address['pincode']}',
                          style: const TextStyle(color: muted, height: 1.5),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Mobile: ${address['phone']}',
                          style: const TextStyle(color: muted),
                        ),

                        const Divider(height: 24),

                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => showAddressForm(index: index),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit'),
                              style: TextButton.styleFrom(
                                foregroundColor: primary,
                              ),
                            ),

                            TextButton.icon(
                              onPressed: () => deleteAddress(index),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Delete'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),

                            const Spacer(),

                            if (!isDefault)
                              TextButton(
                                onPressed: () => setDefault(index),
                                child: const Text(
                                  'Set Default',
                                  style: TextStyle(color: primary),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddressForm(),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, size: 75, color: primary),

            const SizedBox(height: 18),

            const Text(
              'No saved addresses yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: brown,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add your delivery address to make ordering easier.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted),
            ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: () => showAddressForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
