/// App color palette definitions.
///
/// This file centralizes all color definitions used throughout the application,
/// ensuring consistent theming and making it easier to update or modify the
/// app's color scheme in one place.
import 'package:flutter/material.dart';

/// Contains all the colors used in the application.
///
/// Colors are organized by category (main palette, text, semantic, UI elements)
/// to make it easier to find and use the appropriate color for each context.
class AppColors {
  // Main color palette - modern, clean look
  /// Primary brand color - used for main CTAs, app bar backgrounds, etc.
  static const Color primary = Color(0xFF004CFF); // Blue

  /// Lighter variant of the primary color - used for states, highlights
  static const Color primaryLight = Color(0xFF4D7EFF); // Light blue

  /// Secondary/accent color - used for floating buttons, accents
  static const Color secondary = Color(0xFF03DAC6); // Teal

  /// Main background color for screens
  static const Color background = Color(0xFFF5F5F7); // Off-white

  /// Surface color for cards, dialogs, etc.
  static const Color surface = Color(0xFFFFFFFF); // Pure white

  /// Color for error states and messages
  static const Color error = Color(0xFFB00020); // Error red

  // Text colors
  /// Primary text color for headings and body text
  static const Color text = Color(0xFF121212); // Near black

  /// Secondary text color for less emphasis
  static const Color textLight = Color(0xFF666666); // Medium gray

  /// Muted text color for placeholders, disabled states
  static const Color textMuted = Color(0xFF9E9E9E); // Light gray

  // Semantic colors
  /// Color for success states and confirmations
  static const Color success = Color(0xFF4CAF50); // Green

  /// Color for dangerous actions and errors
  static const Color danger = Color(0xFFE53935); // Red

  /// Color for warnings and cautions
  static const Color warning = Color(0xFFFFC107); // Amber

  /// Color for informational states
  static const Color info = Color(0xFF2196F3); // Blue

  // UI element colors
  /// Color for dividers and separators
  static const Color divider = Color(0xFFEEEEEE); // Light gray

  /// Color for shadows with opacity
  static const Color shadow = Color(0x1A000000); // Black with opacity

  /// Color for discount badges and labels
  static const Color discount = Color(0xFF00C853); // Green for discounts
}
