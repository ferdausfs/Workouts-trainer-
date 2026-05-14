# 🚀 PulseFit AI Deployment Guide

## 1. Prerequisites

- Flutter SDK 3.19+
- Android Studio Hedgehog or newer
- JDK 17
- A Google Play Console account ($25 one-time fee)
- A Firebase project

## 2. Local Build

```bash
flutter pub get
flutter build apk --release --split-per-abi
```

Output: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (and 2 more ABI variants).

## 3. Signing for Release

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Create `android/key.properties`:
```
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/Users/you/upload-keystore.jks
```

Build:
```bash
flutter build appbundle --release
```

Upload `app-release.aab` to Google Play Console.

## 4. Firebase Setup

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=pulsefit-ai
```

Add `google-services.json` to `android/app/`.

## 5. Play Store Listing

See `docs/PLAY_STORE_LISTING.md` for ready copy.

Required assets:
- App icon **512×512 PNG**
- Feature graphic **1024×500**
- 2-8 phone screenshots **1080×1920**
- Privacy policy URL

## 6. CI/CD (Codemagic)

1. Sign up at https://codemagic.io
2. Connect this GitHub repo
3. Add environment groups:
   - `keystore_credentials`: CM_KEYSTORE, CM_KEYSTORE_PASSWORD, CM_KEY_ALIAS, CM_KEY_PASSWORD
   - `google_play`: GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
4. Push to `main` → automatic build + upload to Play internal track.

## 7. Versioning

Bump `pubspec.yaml`:
```yaml
version: 1.0.1+2   # name+code
```

## 8. Crash Reporting

Add Firebase Crashlytics:
```bash
flutter pub add firebase_crashlytics
```

Initialize in `main.dart` after `Firebase.initializeApp()`.

## 9. Performance Tips

- Use `--obfuscate --split-debug-info=symbols/` for production builds.
- Run `flutter build apk --analyze-size` to spot bloat.
- Lazy-load Lottie via `Lottie.asset(..., frameRate: FrameRate.max)`.

## 10. Post-Launch

- Monitor ANR in Play Console
- Track DAU/retention via Firebase Analytics
- A/B test paywall via Firebase Remote Config
