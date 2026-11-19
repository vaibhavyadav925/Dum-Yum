import 'dart:ui';

import 'package:flutter/material.dart';

class PremiumBottomNavBar extends StatelessWidget {
  const PremiumBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.cartCount,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final int cartCount;
  final ValueChanged<int> onDestinationSelected;

  static const Color _gold = Color(0xFFD8B56D);
  static const Color _muted = Color(0xFFB8AAA1);
  static const Color _dark = Color(0xFF211714);

  static const List<_NavItem> _items = [
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavItem(
      Icons.restaurant_menu_outlined,
      Icons.restaurant_menu_rounded,
      'Menu',
    ),
    _NavItem(Icons.shopping_bag_outlined, Icons.shopping_bag_rounded, 'Cart'),
    _NavItem(Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Orders'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final safeIndex = selectedIndex.clamp(0, _items.length - 1);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              height: 76,
              decoration: BoxDecoration(
                color: _dark.withValues(alpha: 0.80),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _gold.withValues(alpha: 0.30),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.06),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final segmentWidth = constraints.maxWidth / _items.length;

                  final pillWidth = segmentWidth * 0.86;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // SINGLE MOVING SELECTION PILL
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 450),
                        curve: Curves.easeInOutCubic,
                        left:
                            (segmentWidth * safeIndex) +
                            ((segmentWidth - pillWidth) / 2),
                        width: pillWidth,
                        top: 8,
                        bottom: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(23),
                            border: Border.all(
                              color: _gold.withValues(alpha: 0.38),
                              width: 0.9,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _gold.withValues(alpha: 0.10),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // NAVIGATION ITEMS
                      Row(
                        children: List.generate(_items.length, (index) {
                          final item = _items[index];
                          final isSelected = safeIndex == index;

                          Widget icon = Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 23,
                            color: isSelected ? _gold : _muted,
                          );

                          if (index == 2) {
                            icon = Badge(
                              label: Text('$cartCount'),
                              isLabelVisible: cartCount > 0,
                              backgroundColor: _gold,
                              textColor: _dark,
                              child: icon,
                            );
                          }

                          return Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => onDestinationSelected(index),
                                splashColor: _gold.withValues(alpha: 0.08),
                                highlightColor: Colors.transparent,
                                child: SizedBox(
                                  height: 76,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AnimatedScale(
                                        scale: isSelected ? 1.13 : 1.0,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeOutBack,
                                        child: icon,
                                      ),
                                      const SizedBox(height: 6),
                                      AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        curve: Curves.easeInOut,
                                        style: TextStyle(
                                          color: isSelected ? _gold : _muted,
                                          fontSize: 10,
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w500,
                                          letterSpacing: isSelected ? 0.3 : 0,
                                        ),
                                        child: Text(
                                          item.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.activeIcon, this.label);

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
