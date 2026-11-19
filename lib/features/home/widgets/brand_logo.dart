import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.restaurant, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 9),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DUM YANI',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: AppColors.primary,
              ),
            ),
            Text(
              'SLOW-COOKED GOODNESS',
              style: TextStyle(
                fontSize: 7,
                letterSpacing: 1.1,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
