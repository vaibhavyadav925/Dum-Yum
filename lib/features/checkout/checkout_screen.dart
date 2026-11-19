import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../profile/saved_addresses_screen.dart';
import '../offers/offers_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _houseController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinController = TextEditingController();
  final _couponController = TextEditingController();

  String _paymentMethod = 'cod';
  bool _placingOrder = false;
  List<Map<String, dynamic>> _savedAddresses = [];
  Map<String, dynamic>? _selectedAddress;
  String? _appliedCouponCode;

  static const int deliveryCharge = 30;

  static const Map<String, Map<String, int>> _coupons = {
    'DUM10': {'type': 1, 'value': 10, 'minimum': 299},
    'WELCOME50': {'type': 0, 'value': 50, 'minimum': 399},
    'BIRYANI20': {'type': 1, 'value': 20, 'minimum': 599},
  };

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('dum_yani_addresses');

    List<Map<String, dynamic>> loadedAddresses = [];
    if (saved != null && saved.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(saved) as List<dynamic>;
      loadedAddresses = decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }

    if (!mounted) return;

    setState(() {
      _savedAddresses = loadedAddresses;
    });

    if (loadedAddresses.isNotEmpty) {
      final defaultAddress = loadedAddresses.firstWhere(
        (address) => address['isDefault'] == true,
        orElse: () => loadedAddresses.first,
      );
      _applySavedAddress(defaultAddress);
    } else {
      setState(() => _selectedAddress = null);
    }
  }

  void _applySavedAddress(Map<String, dynamic> address) {
    setState(() {
      _selectedAddress = address;
      _nameController.text = address['name']?.toString() ?? '';
      _phoneController.text = address['phone']?.toString() ?? '';
      _houseController.text = address['house']?.toString() ?? '';
      _areaController.text = address['area']?.toString() ?? '';
      _cityController.text = address['city']?.toString() ?? '';
      _pinController.text = address['pincode']?.toString() ?? '';
      _landmarkController.clear();
    });
  }

  Future<void> _chooseSavedAddress() async {
    if (_savedAddresses.isEmpty) return;

    final selected = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Choose Delivery Address',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ..._savedAddresses.map((address) {
                final isSelected = identical(address, _selectedAddress);
                final addressType = address['type']?.toString() ?? 'Address';
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Icon(
                    addressType == 'Work'
                        ? Icons.work_outline
                        : addressType == 'Home'
                        ? Icons.home_outlined
                        : Icons.location_on_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text('${address['name'] ?? ''} · $addressType'),
                  subtitle: Text(
                    '${address['house'] ?? ''}, ${address['area'] ?? ''}, '
                    '${address['city'] ?? ''} - ${address['pincode'] ?? ''}',
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () => Navigator.pop(sheetContext, address),
                );
              }),
            ],
          ),
        );
      },
    );

    if (selected != null && mounted) {
      _applySavedAddress(selected);
    }
  }

  Future<void> _manageSavedAddresses() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SavedAddressesScreen()),
    );

    if (mounted) {
      await _loadSavedAddresses();
    }
  }

  Widget _savedAddressSection() {
    final address = _selectedAddress;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Saved delivery addresses',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (address != null) ...[
            Text(
              '${address['name'] ?? ''} · ${address['type'] ?? 'Address'}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${address['house'] ?? ''}, ${address['area'] ?? ''}, '
              '${address['city'] ?? ''} - ${address['pincode'] ?? ''}',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 10),
          ] else
            const Text(
              'No saved address selected. Enter your delivery details below.',
              style: TextStyle(fontSize: 12),
            ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _savedAddresses.isEmpty ? null : _chooseSavedAddress,
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Choose Saved Address'),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _manageSavedAddresses,
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Manage Addresses'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _houseController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _pinController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  int get discount {
    final code = _appliedCouponCode;
    if (code == null) return 0;

    final coupon = _coupons[code];
    if (coupon == null) return 0;

    final subtotal = CartProvider.instance.subtotal;
    if (subtotal < coupon['minimum']!) return 0;

    if (coupon['type'] == 1) {
      return subtotal * coupon['value']! ~/ 100;
    }
    return coupon['value']!;
  }

  int get total => CartProvider.instance.subtotal + deliveryCharge - discount;

  Future<void> _openOffers() async {
    final selectedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const OffersScreen()),
    );

    if (!mounted || selectedCode == null) return;

    _couponController.text = selectedCode;
    _applyCoupon();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    final coupon = _coupons[code];

    if (coupon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code. Please try again.')),
      );
      return;
    }

    final subtotal = CartProvider.instance.subtotal;
    if (subtotal < coupon['minimum']!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Add items worth ₹${coupon['minimum']! - subtotal} more to use $code.',
          ),
        ),
      );
      return;
    }

    setState(() => _appliedCouponCode = code);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$code applied successfully!')));
  }

  void _removeCoupon() {
    setState(() {
      _appliedCouponCode = null;
      _couponController.clear();
    });
  }

  Widget _couponSection() {
    final applied = _appliedCouponCode;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Offers & Coupons',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _openOffers,
                icon: const Icon(Icons.local_offer_outlined, size: 16),
                label: const Text('View offers'),
              ),
              if (applied != null)
                TextButton(
                  onPressed: _removeCoupon,
                  child: const Text('Remove'),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (applied != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      '$applied applied · You save ₹$discount',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                ElevatedButton(
                  onPressed: _applyCoupon,
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 13),
            const Text(
              'Available offers',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _couponOffer('DUM10', '10% off on orders above ₹299'),
            _couponOffer('WELCOME50', '₹50 off on orders above ₹399'),
            _couponOffer('BIRYANI20', '20% off on orders above ₹599'),
          ],
        ],
      ),
    );
  }

  Widget _couponOffer(String code, String description) {
    return InkWell(
      onTap: () {
        _couponController.text = code;
        _applyCoupon();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 17,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $label';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || !RegExp(r'^[6-9][0-9]{9}$').hasMatch(value.trim())) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validatePin(String? value) {
    if (value == null || !RegExp(r'^[1-9][0-9]{5}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit PIN code';
    }
    return null;
  }

  InputDecoration _fieldDecoration(
    String label,
    IconData icon, {
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _sectionTitle(String number, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _addressFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: _fieldDecoration('Full name', Icons.person_outline),
            validator: (value) => _required(value, 'your name'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: _fieldDecoration(
              'Mobile number',
              Icons.phone_outlined,
            ).copyWith(counterText: ''),
            validator: _validatePhone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _houseController,
            textCapitalization: TextCapitalization.words,
            decoration: _fieldDecoration(
              'House / Flat / Building',
              Icons.home_outlined,
            ),
            validator: (value) => _required(value, 'house or flat details'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _areaController,
            textCapitalization: TextCapitalization.words,
            decoration: _fieldDecoration(
              'Street / Area',
              Icons.signpost_outlined,
            ),
            validator: (value) => _required(value, 'street or area'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _landmarkController,
            textCapitalization: TextCapitalization.words,
            decoration: _fieldDecoration(
              'Landmark (optional)',
              Icons.location_on_outlined,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _cityController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration('City', Icons.location_city),
                  validator: (value) => _required(value, 'city'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: _fieldDecoration(
                    'PIN code',
                    Icons.pin,
                  ).copyWith(counterText: ''),
                  validator: _validatePin,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool enabled,
  }) {
    final selected = _paymentMethod == value;

    return InkWell(
      onTap: enabled ? () => setState(() => _paymentMethod = value) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: enabled ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!enabled)
              const Text(
                'Soon',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _orderSummary() {
    final cart = CartProvider.instance;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.name} × ${item.quantity}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '₹${item.totalPrice}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 20),
          _priceRow('Subtotal', cart.subtotal),
          const SizedBox(height: 9),
          _priceRow('Delivery charge', deliveryCharge),
          if (discount > 0) ...[
            const SizedBox(height: 9),
            _priceRow('Coupon discount', -discount, isDiscount: true),
          ],
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total payable',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              Text(
                '₹$total',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, int amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          isDiscount ? '-₹${amount.abs()}' : '₹$amount',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (CartProvider.instance.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Your cart is empty.')));
      return;
    }

    if (_paymentMethod == 'upi') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Online payment is not connected yet. Please choose Cash on Delivery.',
          ),
        ),
      );
      return;
    }

    setState(() => _placingOrder = true);

    final cart = CartProvider.instance;
    final orderItems = cart.items
        .map(
          (item) => OrderLine(
            name: item.name,
            quantity: item.quantity,
            price: item.price,
            total: item.totalPrice,
          ),
        )
        .toList();

    final orderNumber =
        'DY${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final address = [
      _houseController.text.trim(),
      _areaController.text.trim(),
      if (_landmarkController.text.trim().isNotEmpty)
        'Near ${_landmarkController.text.trim()}',
      _cityController.text.trim(),
      _pinController.text.trim(),
    ].join(', ');

    final customerName = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final orderSubtotal = cart.subtotal;
    final orderTotal = total;
    final orderDiscount = discount;

    // Save the order in the in-memory order provider before clearing the cart.
    await OrderProvider.instance.addOrder(
      CustomerOrder(
        id: orderNumber,
        customerName: customerName,
        phone: phone,
        address: address,
        items: orderItems
            .map(
              (item) => OrderItem(
                name: item.name,
                quantity: item.quantity,
                price: item.price,
                total: item.total,
              ),
            )
            .toList(),
        subtotal: orderSubtotal,
        deliveryCharge: deliveryCharge,
        total: orderTotal,
        discount: orderDiscount,
        couponCode: _appliedCouponCode,
        paymentMethod: 'Cash on Delivery',
        createdAt: DateTime.now(),
      ),
    );

    cart.clearCart();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
          orderNumber: orderNumber,
          customerName: customerName,
          phone: phone,
          address: address,
          items: orderItems,
          subtotal: orderSubtotal,
          deliveryCharge: deliveryCharge,
          total: orderTotal,
          discount: orderDiscount,
          couponCode: _appliedCouponCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.background,
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _sectionTitle(
                  '01',
                  'Delivery address',
                  'Where should we deliver your biryani?',
                ),
                const SizedBox(height: 16),
                _savedAddressSection(),
                const SizedBox(height: 15),
                _addressFields(),
                const SizedBox(height: 25),
                _sectionTitle(
                  '02',
                  'Payment method',
                  'Choose how you would like to pay.',
                ),
                _paymentOption(
                  value: 'cod',
                  title: 'Cash on Delivery',
                  subtitle: 'Pay when your order arrives',
                  icon: Icons.payments_outlined,
                  enabled: true,
                ),
                _paymentOption(
                  value: 'upi',
                  title: 'UPI / Online payment',
                  subtitle: 'Online payment gateway will be connected later',
                  icon: Icons.account_balance_wallet_outlined,
                  enabled: false,
                ),
                const SizedBox(height: 25),
                _couponSection(),
                const SizedBox(height: 25),
                _sectionTitle(
                  '03',
                  'Order summary',
                  'Review your items before placing the order.',
                ),
                const SizedBox(height: 14),
                _orderSummary(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _placingOrder ? null : _placeOrder,
                    child: _placingOrder
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text('Place order · ₹$total'),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'By placing your order, you confirm that your delivery details are correct.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
    );
  }
}

class OrderLine {
  final String name;
  final int quantity;
  final int price;
  final int total;

  const OrderLine({
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
  });
}

class OrderSuccessScreen extends StatelessWidget {
  final String orderNumber;
  final String customerName;
  final String phone;
  final String address;
  final List<OrderLine> items;
  final int subtotal;
  final int deliveryCharge;
  final int total;
  final int discount;
  final String? couponCode;

  const OrderSuccessScreen({
    super.key,
    required this.orderNumber,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.total,
    this.discount = 0,
    this.couponCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 35),
            Center(
              child: Container(
                height: 82,
                width: 82,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F2E8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF38834A),
                  size: 52,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Order placed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you, $customerName. Your Dum Yani order has been recorded on this device.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Text(
                    'ORDER REFERENCE',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  SelectableText(
                    orderNumber,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Divider(height: 25),
                  _detailRow('Payment', 'Cash on Delivery'),
                  const SizedBox(height: 10),
                  _detailRow('Phone', phone),
                  const SizedBox(height: 10),
                  _detailRow('Delivery address', address),
                  const Divider(height: 25),
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: _detailRow(
                        '${item.name} × ${item.quantity}',
                        '₹${item.total}',
                      ),
                    ),
                  ),
                  const Divider(height: 20),
                  _detailRow('Subtotal', '₹$subtotal'),
                  const SizedBox(height: 8),
                  _detailRow('Delivery charge', '₹$deliveryCharge'),
                  if (discount > 0) ...[
                    const SizedBox(height: 8),
                    _detailRow(
                      'Coupon discount${couponCode == null ? '' : ' ($couponCode)'}',
                      '-₹$discount',
                    ),
                  ],
                  const Divider(height: 20),
                  _detailRow('Total', '₹$total', bold: true),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Back to Home'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Demo checkout: this order is not sent to a restaurant or delivery team yet. Backend order processing will be added later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool bold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: bold ? AppColors.darkBrown : AppColors.textSecondary,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textPrimary,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
