# PulseFit AI — Personal Build Guide

This is a **personal-use** offline fitness app. No Firebase, no Play Services, no license, no in-app purchases.

## Prerequisites

- Flutter SDK **>= 3.22.0**
- Dart **>= 3.4.0**
- JDK **17**
- Android SDK with API **34**
- A device or emulator running **Android 6.0 (API 23)** or higher

## Quick Start

```bash
flutter pub get
flutter run
```

## Build Release APK (no signing required for personal use)

```bash
# Single fat APK (works on any device)
flutter build apk --release

# Smaller APKs split by CPU architecture (recommended)
flutter build apk --release --split-per-abi
```

Output: `build/app/outputs/flutter-apk/*.apk`

In release mode the app falls back to the debug signing key automatically when no `key.properties` is present — perfect for personal installs.

## Optional: Sign with your own keystore

If you want a properly-signed APK to install on multiple devices:

```bash
keytool -genkey -v -keystore ~/pulsefit-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias pulsefit
```

Then create `android/key.properties`:

```
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=pulsefit
storeFile=/absolute/path/to/pulsefit-keystore.jks
```

Rebuild with `flutter build apk --release`.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `Gradle build failed` | Run `flutter clean && flutter pub get` then rebuild |
| `Java version mismatch` | Ensure JDK 17 is active (`java -version`) |
| `flutter.sdk not set in local.properties` | Run `flutter run` once — it auto-creates `local.properties` |
| APK too large | Use `--split-per-abi` to ship smaller per-architecture APKs |
| Notifications don't fire on Android 13+ | Grant `POST_NOTIFICATIONS` runtime permission on first launch |

## What was stripped from the original project

- All Firebase plugins and `google-services.json`
- `com.google.gms.google-services` Gradle plugin
- `google_sign_in`, `sign_in_with_apple`
- `in_app_purchase` (and the Play Billing library it pulls in)
- `pedometer`, `lottie`, `rive`, `glassmorphism`, `sqflite`, `flutter_chat_ui`
- `firebase_options.dart`, `.env.example`, `codemagic.yaml`
- All Play Store / Codemagic publishing config
- Riverpod/Freezed/JSON codegen (kept classic providers — faster builds, no `build_runner` needed)
