import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'brand_logo.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: BrandLogo()),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border, color: AppColors.secondary),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
