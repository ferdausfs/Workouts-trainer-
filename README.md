# PulseFit AI — Personal Edition

A premium AI-powered fitness app for **personal use only**.
100% offline. No Firebase. No Google Play Services. No license required. No tracking. No ads.

---

## ✨ What's inside

- 🏋️ AI-personalized workout plans (rule-based, offline)
- 📚 60+ built-in exercises across all muscle groups
- 🥗 Nutrition tracking with macro calculator (BMR / TDEE / 1RM)
- 📈 Progress charts & body analytics
- 🤖 Local AI coach (rule-based responses, fully offline)
- 🌙 Beautiful glassmorphism dark/light themes
- 🔔 Local workout reminders
- 💾 All data stored locally via Hive + SharedPreferences

---

## 🛠️ What was removed in this build

This is a clean "Personal Edition" — the following cloud / commercial dependencies were removed:

| Removed                                  | Reason                                  |
|------------------------------------------|------------------------------------------|
| `firebase_core`, `firebase_auth`         | No cloud sync needed                    |
| `cloud_firestore`, `firebase_storage`    | All data is local                       |
| `firebase_analytics`, `firebase_messaging` | No tracking, no remote push           |
| `google_sign_in`, `sign_in_with_apple`   | No social login                         |
| `in_app_purchase`                        | App is free — no billing required       |
| `pedometer`                              | Optional sensor — removed for stability |
| `lottie`, `rive`                         | Replaced with `flutter_animate`         |
| `glassmorphism`                          | Custom `GlassCard` using `BackdropFilter` |
| `sqflite`                                | Hive covers all storage needs           |
| `flutter_chat_ui`                        | Custom lightweight chat UI              |
| `google-services` Gradle plugin          | Not needed without Firebase             |
| `google-services.json`                   | Removed                                 |
| Codemagic / Play Store publishing config | Not needed for personal use             |
| `riverpod_generator` + codegen deps      | Using classic providers (faster builds) |

Permissions trimmed to the minimum required for a personal fitness app.

---

## 🚀 Build & run

```bash
flutter pub get
flutter run                       # debug
flutter build apk --release       # single release APK
flutter build apk --release --split-per-abi   # smaller per-architecture APKs
```

### Requirements
- Flutter **>=3.22.0**
- Dart **>=3.4.0**
- Android **minSdk 23, targetSdk 34**
- Java 17

---

## 📂 Project structure

```
lib/
├── core/
│   ├── constants/      # App constants
│   ├── theme/          # Colors + themes
│   ├── utils/          # BMR, TDEE, BMI, 1RM calculators
│   ├── services/       # Notifications, local storage, AI workout generator
│   └── network/        # Dio client (kept for optional image caching)
├── data/local/         # Exercise & food databases (bundled)
├── domain/entities/    # Pure Dart entity models
└── presentation/
    ├── screens/        # All UI screens
    ├── widgets/        # Reusable widgets (GlassCard, GradientButton, …)
    ├── controllers/    # Riverpod state notifiers
    └── routes/         # go_router config
```

---

## 🔐 Privacy

Everything stays on **your device**. No account. No internet required after install.
No analytics, no crash reporters, no remote config — nothing leaves the phone.

---

## 📜 License

Personal use. See `LICENSE`.
