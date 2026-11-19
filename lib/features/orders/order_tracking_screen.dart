import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/order_model.dart';

class OrderTrackingScreen extends StatelessWidget {
  final CustomerOrder order;

  const OrderTrackingScreen({super.key, required this.order});

  static const List<String> stages = [
    'Placed',
    'Confirmed',
    'Preparing',
    'Out for Delivery',
    'Delivered',
  ];

  int get currentStage {
    final index = stages.indexOf(order.status);
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ORDER STATUS',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 9,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  order.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'serif',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Order ${order.id}',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Your order progress will update here when the restaurant and delivery team are connected.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'TRACKING TIMELINE',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 9,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(stages.length, (index) {
            final complete = index <= currentStage;
            final isLast = index == stages.length - 1;
            final icons = [
              Icons.receipt_long,
              Icons.check_circle_outline,
              Icons.soup_kitchen_outlined,
              Icons.delivery_dining,
              Icons.home_outlined,
            ];

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 38,
                    child: Column(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: complete
                                ? AppColors.primary
                                : AppColors.border,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icons[index],
                            size: 16,
                            color: complete
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: index < currentStage
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stages[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: complete
                                  ? AppColors.darkBrown
                                  : AppColors.textSecondary,
                            ),
                          ),
                          if (index == currentStage) ...[
                            const SizedBox(height: 4),
                            const Text(
                              'Current order stage',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
          _infoCard(
            icon: Icons.location_on_outlined,
            title: 'Delivery address',
            value: order.address,
          ),
          const SizedBox(height: 12),
          _infoCard(
            icon: Icons.phone_outlined,
            title: 'Contact number',
            value: order.phone,
          ),
          const SizedBox(height: 20),
          const Text(
            'ORDER ITEMS',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 9,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 11),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                _priceRow('Subtotal', order.subtotal),
                const SizedBox(height: 8),
                _priceRow('Delivery', order.deliveryCharge),
                const Divider(),
                _priceRow('Total paid on delivery', order.total, bold: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Demo tracking: the order is stored only in this app session. Live status updates will be enabled after backend integration.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, int amount, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '₹$amount',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: bold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
