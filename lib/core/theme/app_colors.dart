import 'package:flutter/material.dart';

/// EthioShop Color System
/// Enforces strict brand consistency across the application
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Brand Color
  static const Color primary = Color(0xFF081124); // Dark blue black
  static const Color primaryDark = Color(0xFF050C18);

  // Header Gradient
  static const Color gradientStart = Color(0xFF2E2A72);
  static const Color gradientEnd = Color(0xFF3B368F);

  // Secondary Accent
  static const Color accent = Color(0xFF4C6FFF); // Soft Royal Blue
  static const Color accentLight = Color(0xFF7B8FFF);

  // Notification/Badge
  static const Color notification = Color(0xFFFFC83D); // Yellow

  // Background System
  static const Color background = Color(0xFFF5F6FA);
  static const Color backgroundDark = Color(0xFF12121C);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF1E1E2D);
  static const Color divider = Color(0xFFE6E8F0);
  static const Color dividerDark = Color(0xFF2A2A3D);

  // Text System
  static const Color textPrimary = Color(0xFF1E1E2D);
  static const Color textSecondary = Color(0xFF7A7A9D);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFB8B8C8);

  // Status Colors
  static const Color success = Color(0xFF27C27C);
  static const Color error = Color(0xFFFF4D4F);
  static const Color warning = Color(0xFFFFC83D);
  static const Color info = Color(0xFF4C6FFF);

  // Rating Stars
  static const Color starActive = Color(0xFFFFB400);
  static const Color starInactive = Color(0xFFD6D6E7);

  // Button System
  static const Color buttonPrimary = Color(0xFF2E2A72);
  static const Color buttonSecondary = Color(0xFFF1F2F8);
  static const Color buttonSecondaryDark = Color(0xFF2A2A3D);

  // Shadows
  static List<BoxShadow> get primaryShadow => [
        BoxShadow(
          color: const Color(0xFF2E2A72).withOpacity(0.25),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // Gradients
  static LinearGradient get headerGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientStart, gradientEnd],
      );

  static LinearGradient get logoGradient => LinearGradient(
        colors: [
          Color(0xFF2E2A72),
          Color(0xFF4C6FFF),
          Color(0xFFFFC83D),
          Color(0xFFFF4D4F),
        ],
      );
}