import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class DeliveryLocation extends StatelessWidget {
  const DeliveryLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: AppColors.primary, size: 21),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DELIVERING TO',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Select your location',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.keyboard_arrow_down, color: AppColors.secondary),
      ],
    );
  }
}
