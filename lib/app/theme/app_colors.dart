import 'package:flutter/material.dart';

/// Curated color tokens for Light and Dark themes following modern UI design heuristics.
class AppColors {
  AppColors._();

  // Primary brand accents
  static const Color primary = Color(0xFF4F46E5); // Modern Indigo
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color secondary = Color(0xFF06B6D4); // Cyan Accent

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFF1F5F9);

  // Dark Theme Palette (Sleek Midnight / Slate)
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF131B2E);
  static const Color darkCard = Color(0xFF182238);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkDivider = Color(0xFF162032);

  // Status & Destructive
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Note Card Subtle Preset Tints (Light Mode)
  static const List<Color> lightCardPresets = [
    Color(0xFFFFFFFF), // Default pure white
    Color(0xFFEFF6FF), // Soft Sky
    Color(0xFFF0FDF4), // Soft Mint
    Color(0xFFFFFBEB), // Soft Amber
    Color(0xFFFDF2F8), // Soft Rose
    Color(0xFFF5F3FF), // Soft Lavender
  ];

  // Note Card Subtle Preset Tints (Dark Mode)
  static const List<Color> darkCardPresets = [
    Color(0xFF182238), // Default Midnight Slate
    Color(0xFF1E2A4A), // Deep Sky
    Color(0xFF1A332C), // Deep Mint
    Color(0xFF382E1E), // Deep Amber
    Color(0xFF381E2F), // Deep Rose
    Color(0xFF28214A), // Deep Lavender
  ];
}
