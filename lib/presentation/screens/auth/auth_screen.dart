import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/pulse_logo.dart';
import '../../../core/theme/app_colors.dart';

/// Local-only auth screen.
/// No Google / Apple / Firebase sign-in — purely a local "get started" flow.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _loading = false;

  Future<void> _continueLocal() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const PulseLogo(size: 90),
                const SizedBox(height: 24),
                Text('Welcome to PulseFit',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        )).animate().fadeIn().slideY(begin: 0.2),
                const SizedBox(height: 8),
                Text('100% offline — your data stays on your device',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center)
                    .animate()
                    .fadeIn(delay: 200.ms),
                const Spacer(),
                _featureRow(Icons.lock_outline, 'Private — no account needed'),
                const SizedBox(height: 12),
                _featureRow(Icons.cloud_off_outlined, 'No internet required'),
                const SizedBox(height: 12),
                _featureRow(Icons.fitness_center, 'Built-in exercise library'),
                const SizedBox(height: 32),
                GradientButton(
                  label: _loading ? 'Starting...' : 'Get Started',
                  icon: Icons.arrow_forward,
                  loading: _loading,
                  onPressed: _continueLocal,
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                const SizedBox(height: 24),
                Text('Personal use only • Free forever',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center)
                    .animate()
                    .fadeIn(delay: 800.ms),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1);
  }
}
