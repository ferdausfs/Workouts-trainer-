import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/gradient_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/local_storage_service.dart';

/// "Pro" screen — kept for UI completeness but all features are FREE.
/// No in-app purchase, no billing, no Google Play Billing.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  final _features = const [
    ('Unlimited AI workout plans', Icons.auto_awesome),
    ('Full exercise library', Icons.movie),
    ('Body analytics & progress tracking', Icons.analytics),
    ('Nutrition logging', Icons.restaurant),
    ('AI coach (rule-based, offline)', Icons.psychology),
    ('100% offline & private', Icons.lock),
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
                    IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close)),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.coralGradient),
                        child: const Icon(Icons.workspace_premium,
                            color: Colors.white, size: 56),
                      ),
                    ).animate().fadeIn().scale(begin: const Offset(0.6, 0.6)),
                    const SizedBox(height: 20),
                    Text('All Features Unlocked',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontWeight: FontWeight.w800))
                        .animate()
                        .fadeIn(delay: 200.ms),
                    const SizedBox(height: 8),
                    Text(
                            'This is a personal-use app. Every feature is free, forever — no subscriptions, no ads, no tracking.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium)
                        .animate()
                        .fadeIn(delay: 300.ms),
                    const SizedBox(height: 28),
                    ..._features.asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.pulseCyan.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(e.value.$2,
                                    color: AppColors.pulseCyan, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                  child: Text(e.value.$1,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600))),
                              const Icon(Icons.check_circle,
                                  color: AppColors.success, size: 20),
                            ],
                          )
                              .animate()
                              .fadeIn(
                                  delay: Duration(
                                      milliseconds: 400 + e.key * 80))
                              .slideX(begin: 0.1),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    GradientButton(
                      label: 'Continue',
                      icon: Icons.check,
                      gradient: AppColors.coralGradient,
                      onPressed: () async {
                        await LocalStorageService.setPremium(true);
                        if (context.mounted) context.pop();
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text('No payment required • Personal use',
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
}
