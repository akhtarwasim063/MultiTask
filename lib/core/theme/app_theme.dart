import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData buildTheme({
    required ThemePalette palette,
    required bool isDark,
  }) {
    final isMatteBlack = palette.id == 'matte_black';
    // If Matt Black is selected, the background will always be authentic Matt Black
    final effectiveDark = isMatteBlack ? true : isDark;

    final baseColorScheme = effectiveDark
        ? ColorScheme.dark(
            primary: palette.primary,
            secondary: palette.secondary,
            tertiary: palette.accent,
            surface: isMatteBlack ? const Color(0xFF0E0E11) : palette.darkSurface,
            surfaceContainerLowest: isMatteBlack ? const Color(0xFF000000) : null,
            surfaceContainerLow: isMatteBlack ? const Color(0xFF070709) : null,
            surfaceContainer: isMatteBlack ? const Color(0xFF0E0E11) : null,
            surfaceContainerHigh: isMatteBlack ? const Color(0xFF141418) : null,
            surfaceContainerHighest: isMatteBlack ? const Color(0xFF1A1A20) : null,
            onPrimary: isMatteBlack ? const Color(0xFF000000) : Colors.white,
            onSecondary: isMatteBlack ? const Color(0xFF000000) : Colors.white,
            onSurface: Colors.white,
            onSurfaceVariant: isMatteBlack ? const Color(0xFFCBD5E1) : const Color(0xFF94A3B8),
            outline: isMatteBlack
                ? const Color(0xFF2B2D30)
                : Colors.white.withValues(alpha: 0.12),
            outlineVariant: isMatteBlack
                ? const Color(0xFF1E2024)
                : Colors.white.withValues(alpha: 0.08),
          )
        : ColorScheme.light(
            primary: palette.primary,
            secondary: palette.secondary,
            tertiary: palette.accent,
            surface: const Color(0xFFFFFFFF),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: const Color(0xFF0F172A),
            onSurfaceVariant: const Color(0xFF475569),
            outline: Colors.black.withValues(alpha: 0.08),
          );

    final rawTextTheme = effectiveDark
        ? GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    final textTheme = effectiveDark
        ? rawTextTheme.copyWith(
            displayLarge: rawTextTheme.displayLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            displayMedium: rawTextTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            displaySmall: rawTextTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            headlineLarge: rawTextTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            headlineMedium: rawTextTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            headlineSmall: rawTextTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            titleLarge: rawTextTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            titleMedium: rawTextTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            titleSmall: rawTextTheme.titleSmall?.copyWith(color: const Color(0xFFF1F5F9), fontWeight: FontWeight.w600),
            bodyLarge: rawTextTheme.bodyLarge?.copyWith(color: const Color(0xFFF1F5F9)),
            bodyMedium: rawTextTheme.bodyMedium?.copyWith(color: const Color(0xFFE2E8F0)),
            bodySmall: rawTextTheme.bodySmall?.copyWith(color: const Color(0xFFCBD5E1)),
            labelLarge: rawTextTheme.labelLarge?.copyWith(color: const Color(0xFFF1F5F9), fontWeight: FontWeight.w600),
            labelMedium: rawTextTheme.labelMedium?.copyWith(color: const Color(0xFFCBD5E1)),
            labelSmall: rawTextTheme.labelSmall?.copyWith(color: const Color(0xFFCBD5E1)),
          )
        : rawTextTheme;

    final scaffoldBg = effectiveDark ? (isMatteBlack ? const Color(0xFF000000) : palette.darkBackground) : const Color(0xFFF8FAFC);

    return ThemeData(
      useMaterial3: true,
      colorScheme: baseColorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: isMatteBlack ? const Color(0xFF000000) : Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: isMatteBlack ? const Color(0xFF0E0E11) : baseColorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isMatteBlack ? const Color(0xFF2B2D30) : (effectiveDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isMatteBlack ? const Color(0xFF0E0E11) : baseColorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isMatteBlack ? const Color(0xFF2B2D30) : Colors.white12),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isMatteBlack ? const Color(0xFF0E0E11) : baseColorScheme.surface,
        modalBackgroundColor: isMatteBlack ? const Color(0xFF0E0E11) : baseColorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isMatteBlack ? const Color(0xFF2B2D30) : (effectiveDark ? Colors.white10 : Colors.black12),
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isMatteBlack ? const Color(0xFF141418) : (effectiveDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04)),
        selectedColor: palette.primary.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: baseColorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isMatteBlack ? const Color(0xFF2B2D30) : (effectiveDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08)),
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: isMatteBlack ? const Color(0xFF070709) : (effectiveDark ? palette.darkSurface : Colors.white),
        selectedIconTheme: IconThemeData(color: palette.primary),
        unselectedIconTheme: const IconThemeData(color: Color(0xFFCBD5E1)),
        selectedLabelTextStyle: TextStyle(
          color: palette.primary,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: Color(0xFFCBD5E1),
          fontSize: 12,
        ),
        indicatorColor: palette.primary.withValues(alpha: 0.2),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isMatteBlack ? const Color(0xFF070709) : (effectiveDark ? palette.darkSurface : Colors.white),
        elevation: 8,
        indicatorColor: palette.primary.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(color: palette.primary, fontWeight: FontWeight.w700, fontSize: 11);
          }
          return const TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 11,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isMatteBlack ? const Color(0xFF0E0E11) : (effectiveDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isMatteBlack ? const Color(0xFF2B2D30) : (effectiveDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1))),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isMatteBlack ? const Color(0xFF2B2D30) : (effectiveDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1))),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: isMatteBlack ? const Color(0xFF000000) : Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }
}
