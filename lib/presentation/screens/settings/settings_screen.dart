import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/theme_controller.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/local_storage_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider);
    final themeMode = ref.watch(themeControllerProvider);

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
                  const SizedBox(width: 8),
                  Text('Settings', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 16),
              if (user != null) GlassCard(
                child: Row(
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                      alignment: Alignment.center,
                      child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                          Text('${user.age} y • ${user.weightKg.toInt()} kg • ${user.heightCm.toInt()} cm',
                              style: const TextStyle(color: Colors.grey)),
                          if (!user.isPremium)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: GestureDetector(
                                onTap: () => context.push('/paywall'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.coralGradient,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('UPGRADE TO PRO',
                                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _section('Appearance'),
              GlassCard(
                child: Column(
                  children: [
                    _tile(Icons.dark_mode_rounded, 'Dark theme',
                      trailing: Switch(
                        value: themeMode == ThemeMode.dark,
                        onChanged: (_) => ref.read(themeControllerProvider.notifier).toggle(),
                        activeColor: AppColors.pulseCyan,
                      ),
                    ),
                    const Divider(),
                    _tile(Icons.language, 'Language', subtitle: 'English'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _section('Notifications'),
              GlassCard(
                child: Column(
                  children: [
                    _tile(Icons.notifications, 'Workout reminders', trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppColors.pulseCyan)),
                    const Divider(),
                    _tile(Icons.restaurant, 'Meal reminders', trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppColors.pulseCyan)),
                    const Divider(),
                    _tile(Icons.water_drop, 'Water reminders', trailing: Switch(value: false, onChanged: (_) {}, activeColor: AppColors.pulseCyan)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _section('Data & Privacy'),
              GlassCard(
                child: Column(
                  children: [
                    _tile(Icons.cloud_sync, 'Sync data'),
                    const Divider(),
                    _tile(Icons.download, 'Export progress (CSV)'),
                    const Divider(),
                    _tile(Icons.privacy_tip, 'Privacy policy'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _section('Account'),
              GlassCard(
                child: Column(
                  children: [
                    _tile(Icons.help, 'Help & Support'),
                    const Divider(),
                    _tile(Icons.info, 'About PulseFit AI'),
                    const Divider(),
                    _tile(Icons.logout, 'Sign out', color: AppColors.error, onTap: () async {
                      await ref.read(userControllerProvider.notifier).logout();
                      await LocalStorageService.setOnboardingComplete(false);
                      if (context.mounted) context.go('/welcome');
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Center(child: Text('PulseFit AI v1.0.0', style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
    child: Text(label.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.pulseCyan, letterSpacing: 1.5)),
  );

  Widget _tile(IconData icon, String label, {String? subtitle, Widget? trailing, Color? color, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
