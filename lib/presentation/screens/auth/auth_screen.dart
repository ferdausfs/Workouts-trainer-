import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/pulse_logo.dart';
import '../../../core/theme/app_colors.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _loading = false;

  Future<void> _signInGuest() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
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
                Text('Sign in to sync your progress everywhere',
                    style: Theme.of(context).textTheme.bodyMedium)
                    .animate().fadeIn(delay: 200.ms),
                const Spacer(),
                _authBtn('Continue with Google', Icons.g_mobiledata, Colors.white, Colors.black,
                    () => _signInGuest()).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                const SizedBox(height: 12),
                _authBtn('Continue with Apple', Icons.apple, Colors.black, Colors.white,
                    () => _signInGuest()).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                const SizedBox(height: 12),
                _authBtn('Continue with Email', Icons.mail_outline,
                    AppColors.darkCard, Colors.white,
                    () => _signInGuest()).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: Theme.of(context).textTheme.bodySmall),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                GradientButton(
                  label: _loading ? 'Loading...' : 'Continue as Guest',
                  icon: Icons.person_outline,
                  loading: _loading,
                  onPressed: _signInGuest,
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 24),
                Text('By continuing you accept our Terms & Privacy Policy',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center).animate().fadeIn(delay: 800.ms),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _authBtn(String label, IconData icon, Color bg, Color fg, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg, foregroundColor: fg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
