import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class AdvanceBookingScreen extends StatefulWidget {
  const AdvanceBookingScreen({super.key});

  @override
  State<AdvanceBookingScreen> createState() => _AdvanceBookingScreenState();
}

class _AdvanceBookingScreenState extends State<AdvanceBookingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  static const List<String> _timeSlots = [
    '12:00 PM – 1:00 PM',
    '1:00 PM – 2:00 PM',
    '2:00 PM – 3:00 PM',
    '7:00 PM – 8:00 PM',
    '8:00 PM – 9:00 PM',
    '9:00 PM – 10:00 PM',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final today = DateTime.now();
    final firstDate = DateTime(
      today.year,
      today.month,
      today.day,
    ).add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(firstDate)
          ? firstDate
          : _selectedDate,
      firstDate: firstDate,
      lastDate: firstDate.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(primary: AppColors.primary, surface: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  String get _formattedDate {
    final date = _selectedDate;
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _confirmBooking() async {
    final cart = CartProvider.instance;

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add items to your cart before scheduling.'),
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery time slot.')),
      );
      return;
    }

    final customerName = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (customerName.isEmpty ||
        !RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone) ||
        address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter your name, valid mobile number and delivery address.',
          ),
        ),
      );
      return;
    }

    final items = cart.items
        .map(
          (item) => OrderItem(
            name: item.name,
            quantity: item.quantity,
            price: item.price,
            total: item.totalPrice,
          ),
        )
        .toList();
    final subtotal = cart.subtotal;
    const deliveryCharge = 30;
    final total = subtotal + deliveryCharge;
    final orderNumber =
        'DY${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(
          Icons.event_available_rounded,
          color: AppColors.primary,
          size: 42,
        ),
        title: const Text(
          'Review scheduled order',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: $_formattedDate'),
              const SizedBox(height: 5),
              Text('Time: $_selectedTime'),
              const SizedBox(height: 5),
              Text('Name: $customerName'),
              const SizedBox(height: 5),
              Text('Phone: $phone'),
              const SizedBox(height: 5),
              Text('Address: $address'),
              const Divider(height: 22),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.name} × ${item.quantity}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        '₹${item.total}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 18),
              _summaryRow('Subtotal', '₹$subtotal'),
              const SizedBox(height: 6),
              _summaryRow('Delivery charge', '₹$deliveryCharge'),
              const Divider(height: 18),
              _summaryRow('Total', '₹$total', bold: true),
              const SizedBox(height: 12),
              const Text(
                'This booking will be saved on this device only. The selected time slot is a preference and is not verified with the restaurant.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Edit details'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirm booking'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await OrderProvider.instance.addOrder(
        CustomerOrder(
          id: orderNumber,
          customerName: customerName,
          phone: phone,
          address: address,
          items: items,
          subtotal: subtotal,
          deliveryCharge: deliveryCharge,
          total: total,
          paymentMethod: 'Cash on Delivery',
          createdAt: DateTime.now(),
          status: 'Scheduled',
          scheduledFor: _selectedDate,
          scheduledTime: _selectedTime!,
        ),
      );

      cart.clearCart();
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Color(0xFF38834A),
            size: 48,
          ),
          title: const Text('Booking saved!'),
          content: Text(
            'Your scheduled order has been saved on this device.\n\nReference: $orderNumber\n$_formattedDate\n$_selectedTime',
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save booking: $error')));
    }
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.w800 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Advance Booking',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkBrown,
        elevation: 0,
      ),
      body: cart.isEmpty
          ? _EmptyCartState(onBrowse: () => Navigator.pop(context))
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.darkBrown],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(height: 13),
                      Text(
                        'Plan your biryani moment.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Choose a preferred date and time for your order.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const _SectionTitle(
                  number: '01',
                  title: 'Your order',
                  subtitle: 'Items currently in your cart',
                ),
                const SizedBox(height: 13),
                _OrderItemsCard(items: cart.items, subtotal: cart.subtotal),
                const SizedBox(height: 25),
                const _SectionTitle(
                  number: '02',
                  title: 'Choose a date',
                  subtitle: 'Select a date from tomorrow up to 30 days ahead',
                ),
                const SizedBox(height: 13),
                InkWell(
                  onTap: _chooseDate,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EAE1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DELIVERY DATE',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 9,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _formattedDate,
                                style: const TextStyle(
                                  color: AppColors.darkBrown,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.edit_calendar_outlined,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const _SectionTitle(
                  number: '03',
                  title: 'Choose a time slot',
                  subtitle: 'Your preferred delivery window',
                ),
                const SizedBox(height: 13),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _timeSlots.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.65,
                  ),
                  itemBuilder: (context, index) {
                    final slot = _timeSlots[index];
                    final selected = _selectedTime == slot;
                    return InkWell(
                      onTap: () => setState(() => _selectedTime = slot),
                      borderRadius: BorderRadius.circular(11),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withValues(alpha: 0.09)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          slot,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selected
                                ? AppColors.primary
                                : AppColors.darkBrown,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),
                const _SectionTitle(
                  number: '04',
                  title: 'Delivery details',
                  subtitle: 'Where should we deliver your order?',
                ),
                const SizedBox(height: 13),
                _DeliveryDetailsCard(
                  nameController: _nameController,
                  phoneController: _phoneController,
                  addressController: _addressController,
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2E9DD),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Time slots shown here are sample choices. Actual availability and booking confirmation must be checked with Dum Yani.',
                          style: TextStyle(
                            color: AppColors.darkBrown,
                            fontSize: 11,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _confirmBooking,
                    icon: const Icon(Icons.event_available_rounded),
                    label: const Text(
                      'Review scheduled order',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _OrderItemsCard extends StatelessWidget {
  final List<dynamic> items;
  final int subtotal;

  const _OrderItemsCard({required this.items, required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.name} × ${item.quantity}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    '₹${item.totalPrice}',
                    style: const TextStyle(
                      color: AppColors.darkBrown,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Item subtotal',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              Text(
                '₹$subtotal',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveryDetailsCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const _DeliveryDetailsCard({
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 19),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: _decoration('Full name', Icons.person_outline),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: _decoration(
              '10-digit mobile number',
              Icons.phone_outlined,
            ).copyWith(counterText: ''),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: addressController,
            textCapitalization: TextCapitalization.sentences,
            minLines: 2,
            maxLines: 3,
            decoration: _decoration(
              'Full delivery address',
              Icons.location_on_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          width: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
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
                  color: AppColors.darkBrown,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  final VoidCallback onBrowse;

  const _EmptyCartState({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 55,
              color: AppColors.primary,
            ),
            const SizedBox(height: 14),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                color: AppColors.darkBrown,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Add your Dum Yani favourites before scheduling a delivery.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 18),
            ElevatedButton(onPressed: onBrowse, child: const Text('Go back')),
          ],
        ),
      ),
    );
  }
}
