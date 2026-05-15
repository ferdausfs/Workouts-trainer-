# PulseFit AI – Full Project Structure

```
pulsefit_ai/
├── android/                                # Android native config
│   ├── app/
│   │   ├── build.gradle                    # App-level Gradle (signing, SDKs)
│   │   ├── proguard-rules.pro              # Code obfuscation rules
│   │   └── src/main/
│   │       ├── AndroidManifest.xml         # Permissions + main activity
│   │       └── kotlin/com/pulsefit/ai/MainActivity.kt
│   ├── build.gradle
│   ├── gradle.properties
│   └── settings.gradle
│
├── assets/
│   ├── animations/                         # Lottie / Rive exercise animations
│   ├── audio/                              # Workout cues, beep, etc.
│   ├── data/                               # JSON seed (exercises, foods)
│   ├── fonts/                              # Poppins family
│   ├── icons/                              # App icon, foreground, badges
│   └── images/                             # Splash, feature graphic, illustrations
│
├── docs/
│   ├── STRUCTURE.md                        # This file
│   ├── DEPLOYMENT.md                       # Build & publish guide
│   └── PLAY_STORE_LISTING.md               # Store listing template
│
├── lib/
│   ├── main.dart                           # Entry point, app bootstrap
│   ├── firebase_options.dart               # FlutterFire config
│   │
│   ├── core/                               # Cross-cutting concerns
│   │   ├── constants/app_constants.dart    # Global keys, durations, API
│   │   ├── theme/
│   │   │   ├── app_colors.dart             # Brand color system
│   │   │   └── app_theme.dart              # Dark + Light Material 3 themes
│   │   ├── utils/
│   │   │   ├── calculators.dart            # BMR/TDEE/BMI/macros/1RM
│   │   │   └── extensions.dart             # Context, String, Num helpers
│   │   ├── services/
│   │   │   ├── local_storage_service.dart  # Hive + SharedPrefs
│   │   │   ├── notification_service.dart   # Local notifications
│   │   │   └── ai_workout_generator.dart   # Rule-based AI plan engine
│   │   ├── network/api_client.dart         # Dio + interceptors
│   │   ├── errors/failures.dart            # Failure types
│   │   └── animations/                     # Custom animation widgets
│   │
│   ├── data/
│   │   ├── local/
│   │   │   ├── exercise_database.dart      # 25+ built-in exercises
│   │   │   └── food_database.dart          # 20+ food items
│   │   ├── models/                         # DTOs (extend domain entities)
│   │   ├── repositories/                   # Repo implementations
│   │   ├── datasources/                    # Remote + local sources
│   │   └── remote/                         # Firestore / REST clients
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── user_profile.dart           # User + onboarding data
│   │   │   ├── exercise.dart               # Exercise model
│   │   │   ├── workout.dart                # Workout + plan + session
│   │   │   ├── nutrition.dart              # Food, meal, water
│   │   │   └── progress.dart               # Weight, measurement, achievement
│   │   ├── repositories/                   # Abstract contracts
│   │   └── usecases/                       # Application use cases
│   │
│   └── presentation/
│       ├── controllers/                    # Riverpod StateNotifiers
│       │   ├── theme_controller.dart
│       │   ├── user_controller.dart
│       │   ├── onboarding_controller.dart
│       │   └── workout_controller.dart
│       ├── routes/app_router.dart          # GoRouter declarative routes
│       ├── widgets/
│       │   ├── common/
│       │   │   ├── glass_card.dart         # Glassmorphism container
│       │   │   ├── gradient_button.dart    # Press-animated CTA
│       │   │   ├── animated_gradient_background.dart
│       │   │   └── pulse_logo.dart         # Animated brand logo
│       │   ├── cards/                      # Workout/exercise cards
│       │   ├── charts/                     # Wrappers around fl_chart
│       │   ├── buttons/
│       │   ├── inputs/
│       │   └── animations/                 # Reusable Lottie/Rive players
│       └── screens/
│           ├── splash/splash_screen.dart
│           ├── onboarding/
│           │   ├── welcome_screen.dart
│           │   └── onboarding_flow_screen.dart
│           ├── auth/auth_screen.dart
│           ├── home/
│           │   ├── main_navigation_screen.dart   # Bottom nav (glass)
│           │   └── home_screen.dart              # Dashboard
│           ├── workout/
│           │   ├── workout_detail_screen.dart
│           │   └── workout_player_screen.dart    # Fullscreen player
│           ├── exercise/exercise_detail_screen.dart
│           ├── body/body_map_screen.dart          # Interactive muscle map
│           ├── nutrition/nutrition_screen.dart
│           ├── progress/
│           │   ├── progress_screen.dart
│           │   └── progress_detail_screen.dart
│           ├── coach/ai_coach_screen.dart         # Chat AI
│           ├── settings/settings_screen.dart
│           └── subscription/paywall_screen.dart
│
├── .github/workflows/android-build.yml     # GitHub Actions CI
├── codemagic.yaml                          # Codemagic CD pipeline
├── .env.example                            # Env config template
├── .gitignore
├── pubspec.yaml                            # Dart deps + assets + fonts
└── README.md
```

## Module Responsibilities

| Layer | Responsibility | Knows About |
|-------|----------------|-------------|
| `domain/` | Pure business rules, entities | Nothing else |
| `data/` | Data fetching, mapping, persistence | `domain/` |
| `presentation/` | UI, state, navigation | `domain/`, `core/` |
| `core/` | Shared utilities & services | Nothing project-specific |

This separation ensures testability, swappable data sources, and zero coupling between UI and persistence.
