import 'package:flutter/material.dart';

class ThemePalette {
  final String id;
  final String name;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color darkSurface;
  final Color darkBackground;

  const ThemePalette({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.darkSurface,
    required this.darkBackground,
  });
}

class AppPalettes {
  static const List<ThemePalette> palettes = [
    // 0: Cosmic Indigo
    ThemePalette(
      id: 'cosmic_indigo',
      name: 'Cosmic Indigo',
      primary: Color(0xFF6366F1),
      secondary: Color(0xFF818CF8),
      accent: Color(0xFF38BDF8),
      darkSurface: Color(0xFF131722),
      darkBackground: Color(0xFF0B0E14),
    ),
    // 1: Cyber Emerald
    ThemePalette(
      id: 'cyber_emerald',
      name: 'Cyber Emerald',
      primary: Color(0xFF10B981),
      secondary: Color(0xFF34D399),
      accent: Color(0xFF059669),
      darkSurface: Color(0xFF0F1E19),
      darkBackground: Color(0xFF08120E),
    ),
    // 2: Solar Amber
    ThemePalette(
      id: 'solar_amber',
      name: 'Solar Amber',
      primary: Color(0xFFF59E0B),
      secondary: Color(0xFFFBBF24),
      accent: Color(0xFFD97706),
      darkSurface: Color(0xFF1E170F),
      darkBackground: Color(0xFF120E08),
    ),
    // 3: Neon Crimson
    ThemePalette(
      id: 'neon_crimson',
      name: 'Neon Crimson',
      primary: Color(0xFFF43F5E),
      secondary: Color(0xFFFB7185),
      accent: Color(0xFFE11D48),
      darkSurface: Color(0xFF201014),
      darkBackground: Color(0xFF12080A),
    ),
    // 4: Royal Violet
    ThemePalette(
      id: 'royal_violet',
      name: 'Royal Violet',
      primary: Color(0xFF8B5CF6),
      secondary: Color(0xFFA78BFA),
      accent: Color(0xFF7C3AED),
      darkSurface: Color(0xFF191224),
      darkBackground: Color(0xFF0F0A17),
    ),
    // 5: Matt Black (Android Studio Jet Black)
    ThemePalette(
      id: 'matte_black',
      name: 'Matt Black',
      primary: Color(0xFF38BDF8),
      secondary: Color(0xFF818CF8),
      accent: Color(0xFF34D399),
      darkSurface: Color(0xFF0E0E11),
      darkBackground: Color(0xFF000000),
    ),
  ];

  static ThemePalette getPalette(int index) {
    if (index < 0 || index >= palettes.length) {
      return palettes[0];
    }
    return palettes[index];
  }
}
