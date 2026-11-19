import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CategorySection extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategorySection({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const categories = ['All', 'Chicken', 'Mutton', 'Veg', 'Egg'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore Our Menu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 43,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final selected = selectedIndex == index;

              return GestureDetector(
                onTap: () => onSelected(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
