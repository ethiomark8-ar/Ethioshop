import 'package:flutter/material.dart';
import 'app_colors.dart';

/// EthioShop Typography System
/// Primary: Roboto, Fallback: Noto Sans Ethiopic (for Amharic)
class AppTextTheme {
  // Private constructor to prevent instantiation
  AppTextTheme._();

  static const String fontFamilyPrimary = 'Roboto';
  static const String fontFamilyEthiopic = 'NotoSansEthiopic';

  static TextTheme get lightTextTheme {
    return TextTheme(
      // Display Styles
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyPrimary,
        letterSpacing: -0.25,
        color: AppColors.textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),

      // Headline Styles
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),

      // Title Styles
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      ),

      // Body Styles
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0.25,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0.4,
        color: AppColors.textSecondary,
      ),

      // Label Styles
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyPrimary,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      ),
    );
  }

  static TextTheme get darkTextTheme {
    return lightTextTheme.copyWith(
      displayLarge: lightTextTheme.displayLarge?.copyWith(
        color: AppColors.textOnDark,
      ),
      displayMedium: lightTextTheme.displayMedium?.copyWith(
        color: AppColors.textOnDark,
      ),
      displaySmall: lightTextTheme.displaySmall?.copyWith(
        color: AppColors.textOnDark,
      ),
      headlineLarge: lightTextTheme.headlineLarge?.copyWith(
        color: AppColors.textOnDark,
      ),
      headlineMedium: lightTextTheme.headlineMedium?.copyWith(
        color: AppColors.textOnDark,
      ),
      headlineSmall: lightTextTheme.headlineSmall?.copyWith(
        color: AppColors.textOnDark,
      ),
      titleLarge: lightTextTheme.titleLarge?.copyWith(
        color: AppColors.textOnDark,
      ),
      titleMedium: lightTextTheme.titleMedium?.copyWith(
        color: AppColors.textOnDark,
      ),
      titleSmall: lightTextTheme.titleSmall?.copyWith(
        color: AppColors.textOnDark,
      ),
      bodyLarge: lightTextTheme.bodyLarge?.copyWith(
        color: AppColors.textOnDark,
      ),
      bodyMedium: lightTextTheme.bodyMedium?.copyWith(
        color: AppColors.textOnDark,
      ),
      bodySmall: lightTextTheme.bodySmall?.copyWith(
        color: AppColors.textLight,
      ),
      labelLarge: lightTextTheme.labelLarge?.copyWith(
        color: AppColors.textOnDark,
      ),
      labelMedium: lightTextTheme.labelMedium?.copyWith(
        color: AppColors.textOnDark,
      ),
      labelSmall: lightTextTheme.labelSmall?.copyWith(
        color: AppColors.textLight,
      ),
    );
  }
}