# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Hive / Local DB
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin

# Keep model classes
-keep class com.pulsefit.ai.** { *; }

# Local notifications
-keep class com.dexterous.** { *; }

# Audio players
-keep class xyz.luan.** { *; }

# Video player
-keep class androidx.media3.** { *; }

# Suppress warnings
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
