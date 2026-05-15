# 🔥 PulseFit AI — Premium AI Fitness Platform (2026)

> **An original 2026 Android fitness app inspired by premium AI training platforms.**
> Personalized AI workout plans, interactive muscle map, exercise animations, nutrition tracking, AI coach, and beautiful glassmorphism UI.

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-02569B?logo=flutter)](https://flutter.dev)
[![Android](https://img.shields.io/badge/Android-23+-3DDC84?logo=android)](https://www.android.com/)
[![Material](https://img.shields.io/badge/Material-3-757575?logo=material-design)](https://m3.material.io/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## ✨ Features

| Category | Feature |
|----------|---------|
| 🧠 AI | Personalized workout plan generator (goal/level/equipment-aware) |
| 🧠 AI | 24/7 conversational AI coach with smart replies |
| 🏋️ Workouts | 25+ built-in exercises with sets/reps/rest/MET science |
| 🏋️ Workouts | Fullscreen workout player with rest timer & voice cue hooks |
| 🫀 Body | Interactive custom-painted muscle map with tap-to-highlight |
| 🥗 Nutrition | BMR/TDEE calculator (Mifflin-St Jeor), macro breakdown, water tracker |
| 📈 Progress | Weight trend + weekly bar chart + streak + achievements |
| 🎨 UI | Glassmorphism, animated gradients, Material 3, dark + light theme |
| 🚀 UX | 8-step smart onboarding, Apple-grade transitions, gesture nav |
| 🔒 Auth | Google / Apple / Email / Guest mode |
| 💎 Premium | Subscription paywall (Monthly / Yearly / Lifetime) |
| 📴 Offline | Hive + SharedPreferences caching, works without internet |

---

## 🏗️ Architecture (Clean + Riverpod)

```
lib/
├── core/                # constants, theme, services, network, errors, utils
├── data/                # local databases + repositories + datasources
├── domain/              # entities + repositories interfaces + usecases
└── presentation/        # screens, widgets, controllers, routes
    ├── screens/         # splash, onboarding, auth, home, workout, exercise,
    │                    # body, nutrition, progress, coach, settings, paywall
    ├── widgets/         # GlassCard, GradientButton, AnimatedGradientBg, PulseLogo
    ├── controllers/     # Riverpod StateNotifiers (user, theme, workout, onboarding)
    └── routes/          # GoRouter declarative routing
```

**Stack:** Flutter 3.19 · Riverpod 2 · GoRouter · Hive · Firebase · fl_chart · Lottie · Rive · GoogleFonts (Poppins) · flutter_animate.

---

## 🚀 Quick Start

```bash
# 1. Install Flutter SDK 3.19+
flutter --version

# 2. Clone & enter
git clone https://github.com/yourname/pulsefit_ai.git
cd pulsefit_ai

# 3. Install dependencies
flutter pub get

# 4. (Optional) Add real Firebase config
#    Edit lib/firebase_options.dart OR run:
flutterfire configure

# 5. Run
flutter run -d <android-device>
```

> The app **runs without Firebase** — auth and sync are guarded. Use *guest mode* to skip auth.

---

## 📦 Build APK / AAB

```bash
# Debug
flutter run

# Release APK
flutter build apk --release --split-per-abi

# Play Store bundle
flutter build appbundle --release
```

Outputs in `build/app/outputs/`.

### Sign your release

Create `android/key.properties`:
```
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

Generate keystore:
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

---

## 🔥 Firebase Setup

1. Create a Firebase project at https://console.firebase.google.com
2. Add Android app with package `com.pulsefit.ai`
3. Download `google-services.json` → place in `android/app/`
4. Run `flutterfire configure` to auto-generate `firebase_options.dart`

Enable services:
- Authentication (Email, Google, Apple)
- Firestore Database (rules below)
- Cloud Storage (for user avatars)
- Cloud Messaging (push notifications)
- Analytics

### Sample Firestore Rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /exercises/{exerciseId} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

---

## 🤖 CI/CD with Codemagic

A ready-to-use `codemagic.yaml` is included. Connect your repo at https://codemagic.io.

The pipeline:
1. Resolves dependencies
2. Runs unit tests
3. Builds release APK + AAB
4. Uploads artifacts
5. (Optional) Deploys to Google Play internal track

---

## 🎨 Brand Identity

- **App Name:** PulseFit AI
- **Tagline:** Your AI-Powered Fitness Coach
- **Primary:** Electric Pulse Cyan `#00E5FF`
- **Secondary:** Neon Coral `#FF5C8A`
- **Accent:** Aurora Violet `#7C4DFF`
- **Energy:** Lime `#B4FF39`
- **Logo concept:** Bolt-in-circle with cyan→violet gradient + pulsing glow halo

---

## 📂 Project Structure (Full)

See [`docs/STRUCTURE.md`](docs/STRUCTURE.md).

---

## 🧪 Testing

```bash
flutter test
```

---

## 📱 Play Store Assets

- App icon: `assets/icons/app_icon.png` (1024×1024)
- Feature graphic: `assets/images/feature_graphic.png` (1024×500)
- Screenshots: 1080×1920 (phone), 1600×2560 (tablet)

Listing template in [`docs/PLAY_STORE_LISTING.md`](docs/PLAY_STORE_LISTING.md).

---

## ⚖️ License & Originality

**MIT License** — Free for commercial use.

This project is an **original implementation** inspired by general patterns of premium fitness platforms. It does **NOT** copy proprietary branding, assets, or copyrighted UI from any specific service. All exercise data, icons, color systems, and UI compositions are original to this project.

When integrating animations or images, use only **open-source / Creative Commons / self-created** assets (Lottie public library, Rive community files, Unsplash with attribution, etc.).

---

## 🙌 Credits

- Icons: Material Symbols (Apache 2.0)
- Fonts: Poppins via Google Fonts (Open Font License)
- Charts: `fl_chart`
- Animations: `flutter_animate`, `lottie`, `rive`

Made with 💙 by the PulseFit AI team.
