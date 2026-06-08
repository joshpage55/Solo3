import 'package:flutter/material.dart';

/// Five background colors that cycle when the user taps empty screen areas.
class AppBackgroundTheme {
  AppBackgroundTheme._();

  static const List<Color> palette = [
    Color(0xFFFFF8E7), // Warm cream
    Color(0xFF87CEEB), // Sky blue
    Color(0xFFFF6B6B), // Coral red
    Color(0xFF006D77), // Deep teal
    Color(0xFF2D3436), // Charcoal
  ];

  static const List<String> paletteNames = [
    'Warm Cream',
    'Sky Blue',
    'Coral Red',
    'Deep Teal',
    'Charcoal',
  ];

  /// Returns black or white based on [background] luminance for readable contrast.
  static Color foregroundFor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }

  static Color mutedForegroundFor(Color background) {
    final base = foregroundFor(background);
    return base.withValues(alpha: 0.7);
  }

  static Color accentFor(Color background) {
    final isLight = background.computeLuminance() > 0.5;
    return isLight ? const Color(0xFF006D77) : const Color(0xFF87CEEB);
  }
}
