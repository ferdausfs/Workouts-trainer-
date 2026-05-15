import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/onboarding/onboarding_flow_screen.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/main_navigation_screen.dart';
import '../screens/workout/workout_detail_screen.dart';
import '../screens/workout/workout_player_screen.dart';
import '../screens/exercise/exercise_detail_screen.dart';
import '../screens/body/body_map_screen.dart';
import '../screens/coach/ai_coach_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/subscription/paywall_screen.dart';
import '../screens/progress/progress_detail_screen.dart';

import '../../domain/entities/workout.dart';
import '../../domain/entities/exercise.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingFlowScreen()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      GoRoute(path: '/home', builder: (_, __) => const MainNavigationScreen()),
      GoRoute(
        path: '/workout-detail',
        builder: (_, state) => WorkoutDetailScreen(workout: state.extra as Workout),
      ),
      GoRoute(
        path: '/workout-player',
        builder: (_, state) => WorkoutPlayerScreen(workout: state.extra as Workout),
      ),
      GoRoute(
        path: '/exercise-detail',
        builder: (_, state) => ExerciseDetailScreen(exercise: state.extra as Exercise),
      ),
      GoRoute(path: '/body-map', builder: (_, __) => const BodyMapScreen()),
      GoRoute(path: '/coach', builder: (_, __) => const AICoachScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/paywall', builder: (_, __) => const PaywallScreen()),
      GoRoute(path: '/progress', builder: (_, __) => const ProgressDetailScreen()),
    ],
  );
});
