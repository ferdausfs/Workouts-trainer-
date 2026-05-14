import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/gradient_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/local_storage_service.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  int _selectedPlan = 1; // 0 monthly, 1 yearly, 2 lifetime

  final _features = const [
    ('Unlimited AI workout plans', Icons.auto_awesome),
    ('Premium exercise animations', Icons.movie),
    ('Advanced body analytics', Icons.analytics),
    ('Personalized meal plans', Icons.restaurant),
    ('1-on-1 AI coaching', Icons.psychology),
    ('No ads, ever', Icons.block),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Text('Restore')),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    Center(
                      child: Container(
                        width: 100, height: 100,
                        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.coralGradient),
                        child: const Icon(Icons.workspace_premium, color: Colors.white, size: 56),
                      ),
                    ).animate().fadeIn().scale(begin: const Offset(0.6, 0.6)),
                    const SizedBox(height: 20),
                    Text('PulseFit Pro',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800))
                        .animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 8),
                    Text('Unlock your full potential with AI-personalized fitness.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium)
                        .animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 28),
                    ..._features.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.pulseCyan.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(e.value.$2, color: AppColors.pulseCyan, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Text(e.value.$1, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                        ],
                      ).animate().fadeIn(delay: Duration(milliseconds: 400 + e.key * 80)).slideX(begin: 0.1),
                    )),
                    const SizedBox(height: 24),
                    _planCard(0, 'Monthly', '\$9.99', '/month', false),
                    const SizedBox(height: 10),
                    _planCard(1, 'Yearly', '\$59.99', '/year • SAVE 50%', true),
                    const SizedBox(height: 10),
                    _planCard(2, 'Lifetime', '\$149.99', 'One-time', false),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    GradientButton(
                      label: 'Start 7-Day Free Trial',
                      icon: Icons.bolt,
                      gradient: AppColors.coralGradient,
                      onPressed: () async {
                        await LocalStorageService.setPremium(true);
                        if (context.mounted) context.pop();
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text('Cancel anytime • No hidden fees',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _planCard(int index, String title, String price, String period, bool best) {
    final selected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          color: selected ? null : Colors.white.withOpacity(0.05),
          border: Border.all(color: selected ? Colors.transparent : Colors.white24, width: 1.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? Colors.white : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800,
                        color: selected ? Colors.white : null,
                      )),
                      if (best) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('BEST', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black)),
                        ),
                      ],
                    ],
                  ),
                  Text(period, style: TextStyle(fontSize: 12, color: selected ? Colors.white70 : Colors.grey)),
                ],
              ),
            ),
            Text(price, style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800,
              color: selected ? Colors.white : null,
            )),
          ],
        ),
      ),
    );
  }
}
