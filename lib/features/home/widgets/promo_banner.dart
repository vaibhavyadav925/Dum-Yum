import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkBrown,
        borderRadius: BorderRadius.circular(14),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1563379091339-03246963d96c?w=1000',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              AppColors.darkBrown.withValues(alpha: 0.95),
              Colors.transparent,
            ],
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'THE DUM YANI EXPERIENCE',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Royal Taste.\nAuthentic Dum.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Slow-cooked goodness, made with love.',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
