import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search your favourite biryani...',
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          Icon(Icons.tune, color: AppColors.secondary),
        ],
      ),
    );
  }
}
