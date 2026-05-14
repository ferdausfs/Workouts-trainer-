import 'package:flutter/material.dart';

/// PulseFit AI Color System - Original brand identity (2026)
/// Primary: Electric Pulse Cyan, Secondary: Neon Coral, Accent: Aurora Violet
class AppColors {
  AppColors._();

  // === Brand ===
  static const Color pulseCyan = Color(0xFF00E5FF);
  static const Color pulseCyanDark = Color(0xFF00B8D4);
  static const Color neonCoral = Color(0xFFFF5C8A);
  static const Color auroraViolet = Color(0xFF7C4DFF);
  static const Color limeEnergy = Color(0xFFB4FF39);

  // === Gradients ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [pulseCyan, auroraViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coralGradient = LinearGradient(
    colors: [neonCoral, Color(0xFFFF9966)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient energyGradient = LinearGradient(
    colors: [limeEnergy, pulseCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF0A0E27)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightBgGradient = LinearGradient(
    colors: [Color(0xFFF8FAFF), Color(0xFFEEF2FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // === Dark Theme ===
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color darkSurface = Color(0xFF151A35);
  static const Color darkCard = Color(0xFF1E2444);
  static const Color darkBorder = Color(0xFF2A3158);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB4BCD8);
  static const Color darkTextTertiary = Color(0xFF7884B0);

  // === Light Theme ===
  static const Color lightBg = Color(0xFFF8FAFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE4E9F2);
  static const Color lightTextPrimary = Color(0xFF0A0E27);
  static const Color lightTextSecondary = Color(0xFF4A5378);
  static const Color lightTextTertiary = Color(0xFF8893B5);

  // === Semantic ===
  static const Color success = Color(0xFF22D38C);
  static const Color warning = Color(0xFFFFB547);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF3B82F6);

  // === Muscle Group Colors ===
  static const Color chestColor = Color(0xFFFF5C8A);
  static const Color backColor = Color(0xFF7C4DFF);
  static const Color shouldersColor = Color(0xFFFFB547);
  static const Color armsColor = Color(0xFF00E5FF);
  static const Color absColor = Color(0xFFB4FF39);
  static const Color legsColor = Color(0xFF22D38C);
  static const Color cardioColor = Color(0xFFFF4757);

  // Glass effect
  static Color glassWhite(double opacity) => Colors.white.withOpacity(opacity);
  static Color glassBlack(double opacity) => Colors.black.withOpacity(opacity);
}
