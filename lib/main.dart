import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/injection.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/widgets/responsive_scaffold.dart';
import 'features/countries/presentation/screens/countries_screen.dart';
import 'features/github/presentation/screens/github_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/jokes/presentation/screens/jokes_screen.dart';
import 'features/nasa/presentation/screens/nasa_screen.dart';
import 'features/news/presentation/screens/news_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/weather/presentation/screens/weather_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final storageService = SecureStorageService(sharedPreferences);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        themeProvider.overrideWith((ref) => ThemeNotifier(storageService)),
        localeProvider.overrideWith((ref) => LocaleNotifier(storageService)),
      ],
      child: const NexusHubApp(),
    ),
  );
}

class NexusHubApp extends ConsumerWidget {
  const NexusHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final activeLocale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'NexusHub',
      debugShowCheckedModeBanner: false,
      locale: activeLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      theme: AppTheme.buildTheme(palette: themeState.currentPalette, isDark: false),
      darkTheme: AppTheme.buildTheme(palette: themeState.currentPalette, isDark: true),
      themeMode: themeState.themeMode,
      home: const ResponsiveScaffold(screens: [HomeScreen(), WeatherScreen(), CountriesScreen(), NewsScreen(), NasaScreen(), GitHubScreen(), JokesScreen(), SettingsScreen()]),
    );
  }
}
