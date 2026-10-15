import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexushub/core/di/injection.dart';
import 'package:nexushub/core/localization/locale_provider.dart';
import 'package:nexushub/core/storage/secure_storage_service.dart';
import 'package:nexushub/core/theme/app_colors.dart';
import 'package:nexushub/core/theme/app_theme.dart';
import 'package:nexushub/core/theme/theme_provider.dart';
import 'package:nexushub/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('NexusHub app initialization smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = SecureStorageService(prefs);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          themeProvider.overrideWith((ref) => ThemeNotifier(storage)),
          localeProvider.overrideWith((ref) => LocaleNotifier(storage)),
        ],
        child: const NexusHubApp(),
      ),
    );

    // Initial pump
    await tester.pump();
    expect(find.byType(NexusHubApp), findsOneWidget);

    // Drain async timers from HTTP / debouncers
    await tester.pump(const Duration(seconds: 4));
  });

  test('Matt Black palette and theme configuration test', () {
    final matteBlackPalette = AppPalettes.palettes.firstWhere((p) => p.id == 'matte_black');
    expect(matteBlackPalette.name, 'Matt Black');
    expect(matteBlackPalette.darkBackground, const Color(0xFF000000));
    expect(matteBlackPalette.darkSurface, const Color(0xFF0E0E11));

    // Test buildTheme produces true matte black background for both isDark = true and false
    final darkTheme = AppTheme.buildTheme(palette: matteBlackPalette, isDark: true);
    expect(darkTheme.scaffoldBackgroundColor, const Color(0xFF000000));
    expect(darkTheme.colorScheme.surface, const Color(0xFF0E0E11));
    expect(darkTheme.colorScheme.onPrimary, const Color(0xFF000000));
    expect(darkTheme.colorScheme.onSurface, Colors.white);

    final lightThemeRequest = AppTheme.buildTheme(palette: matteBlackPalette, isDark: false);
    expect(lightThemeRequest.scaffoldBackgroundColor, const Color(0xFF000000));
    expect(lightThemeRequest.colorScheme.surface, const Color(0xFF0E0E11));
  });

  test('ThemeNotifier auto-activates dark mode on Matt Black selection', () async {
    SharedPreferences.setMockInitialValues({'ui_theme_mode': 'light'});
    final prefs = await SharedPreferences.getInstance();
    final storage = SecureStorageService(prefs);
    final notifier = ThemeNotifier(storage);

    expect(notifier.state.themeMode, ThemeMode.light);

    final matteIndex = AppPalettes.palettes.indexWhere((p) => p.id == 'matte_black');
    expect(matteIndex, isNonNegative);

    notifier.setPalette(matteIndex);
    expect(notifier.state.paletteIndex, matteIndex);
    expect(notifier.state.themeMode, ThemeMode.dark);
  });
}
