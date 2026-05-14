import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/gradient_button.dart';
import '../../../core/theme/app_colors.dart';

class _Slide {
  final String title;
  final String desc;
  final IconData icon;
  const _Slide(this.title, this.desc, this.icon);
}

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _pc = PageController();
  int _page = 0;

  final _slides = const [
    _Slide(
      'AI-Powered\nWorkout Plans',
      'Personalized fitness plans crafted by AI based on your goals, body, and equipment.',
      Icons.auto_awesome_rounded,
    ),
    _Slide(
      'Interactive\nMuscle Map',
      'Tap any muscle to discover targeted exercises and see real-time activation.',
      Icons.accessibility_new_rounded,
    ),
    _Slide(
      'Smart Nutrition\n& Coaching',
      'Track macros, water, sleep, and chat with your 24/7 AI fitness coach.',
      Icons.restaurant_menu_rounded,
    ),
  ];

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pc,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemCount: _slides.length,
                  itemBuilder: (_, i) => _buildSlide(_slides[i], i),
                ),
              ),
              SmoothPageIndicator(
                controller: _pc,
                count: _slides.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppColors.pulseCyan,
                  dotColor: Colors.white24,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 6,
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GradientButton(
                  label: _page == _slides.length - 1 ? 'Get Started' : 'Continue',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    if (_page == _slides.length - 1) {
                      context.go('/onboarding');
                    } else {
                      _pc.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/auth'),
                child: const Text('Already have an account? Sign in'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(_Slide s, int index) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(color: AppColors.pulseCyan.withOpacity(0.4), blurRadius: 40, spreadRadius: 4),
              ],
            ),
            child: Icon(s.icon, color: Colors.white, size: 100),
          )
              .animate(key: ValueKey(index))
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.7, 0.7)),
          const SizedBox(height: 48),
          Text(
            s.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ).animate(key: ValueKey('title$index')).fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 20),
          Text(
            s.desc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ).animate(key: ValueKey('desc$index')).fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}
