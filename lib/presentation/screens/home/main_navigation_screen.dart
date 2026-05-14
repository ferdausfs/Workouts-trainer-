import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen.dart';
import '../body/body_map_screen.dart';
import '../nutrition/nutrition_screen.dart';
import '../progress/progress_screen.dart';
import '../coach/ai_coach_screen.dart';
import '../../../core/theme/app_colors.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    BodyMapScreen(),
    NutritionScreen(),
    ProgressScreen(),
    AICoachScreen(),
  ];

  final _items = const [
    _NavItem('Home', Icons.home_rounded),
    _NavItem('Body', Icons.accessibility_new_rounded),
    _NavItem('Nutrition', Icons.restaurant_rounded),
    _NavItem('Progress', Icons.trending_up_rounded),
    _NavItem('Coach', Icons.psychology_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: _pages[_index],
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 30, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.08),
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (i) {
                final selected = _index == i;
                return GestureDetector(
                  onTap: () => setState(() => _index = i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 12, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: selected ? AppColors.primaryGradient : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(_items[i].icon, color: selected ? Colors.white : Colors.grey),
                        if (selected) ...[
                          const SizedBox(width: 6),
                          Text(_items[i].label,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  const _NavItem(this.label, this.icon);
}
