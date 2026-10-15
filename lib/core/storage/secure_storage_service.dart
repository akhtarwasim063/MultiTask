import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting encrypted/local configurations, API keys, and cache
class SecureStorageService {
  final SharedPreferences _prefs;

  SecureStorageService(this._prefs);

  static const String _keyWeatherApiKey = 'cfg_weather_api_key';
  static const String _keyNewsApiKey = 'cfg_news_api_key';
  static const String _keyNasaApiKey = 'cfg_nasa_api_key';
  static const String _keyGitHubToken = 'cfg_github_token';
  static const String _keyUseDemoKeys = 'cfg_use_demo_keys';

  static const String _keyThemeMode = 'ui_theme_mode'; // 'system', 'light', 'dark'
  static const String _keyThemePalette = 'ui_theme_palette'; // int 0-4
  static const String _keyLocale = 'ui_locale'; // 'en', 'es', 'fr', 'de', 'hi', 'ar'
  static const String _keyFrostedGlass = 'ui_frosted_glass_enabled'; // bool

  static const String _keyCustomWidgets = 'hub_custom_widgets';
  static const String _keyFavoriteJokes = 'hub_favorite_jokes';
  static const String _keyOfflineCachePrefix = 'cache_';

  // API Keys
  String? getWeatherApiKey() => _prefs.getString(_keyWeatherApiKey);
  Future<void> setWeatherApiKey(String key) => _prefs.setString(_keyWeatherApiKey, key.trim());

  String? getNewsApiKey() => _prefs.getString(_keyNewsApiKey);
  Future<void> setNewsApiKey(String key) => _prefs.setString(_keyNewsApiKey, key.trim());

  String? getNasaApiKey() => _prefs.getString(_keyNasaApiKey);
  Future<void> setNasaApiKey(String key) => _prefs.setString(_keyNasaApiKey, key.trim());

  String? getGitHubToken() => _prefs.getString(_keyGitHubToken);
  Future<void> setGitHubToken(String token) => _prefs.setString(_keyGitHubToken, token.trim());

  bool getUseDemoKeys() => _prefs.getBool(_keyUseDemoKeys) ?? true;
  Future<void> setUseDemoKeys(bool value) => _prefs.setBool(_keyUseDemoKeys, value);

  // Theming & Locale
  String getThemeMode() => _prefs.getString(_keyThemeMode) ?? 'dark';
  Future<void> setThemeMode(String mode) => _prefs.setString(_keyThemeMode, mode);

  int getThemePaletteIndex() => _prefs.getInt(_keyThemePalette) ?? 0;
  Future<void> setThemePaletteIndex(int index) => _prefs.setInt(_keyThemePalette, index);

  bool getFrostedGlassEnabled() => _prefs.getBool(_keyFrostedGlass) ?? true;
  Future<void> setFrostedGlassEnabled(bool value) => _prefs.setBool(_keyFrostedGlass, value);

  String getLocaleCode() => _prefs.getString(_keyLocale) ?? 'en';
  Future<void> setLocaleCode(String code) => _prefs.setString(_keyLocale, code);

  // Custom Widgets
  List<Map<String, dynamic>> getCustomWidgets() {
    final raw = _prefs.getString(_keyCustomWidgets);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List list = jsonDecode(raw);
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCustomWidgets(List<Map<String, dynamic>> widgets) async {
    final raw = jsonEncode(widgets);
    await _prefs.setString(_keyCustomWidgets, raw);
  }

  // Favorite Jokes
  List<Map<String, dynamic>> getFavoriteJokes() {
    final raw = _prefs.getString(_keyFavoriteJokes);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List list = jsonDecode(raw);
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavoriteJokes(List<Map<String, dynamic>> jokes) async {
    final raw = jsonEncode(jokes);
    await _prefs.setString(_keyFavoriteJokes, raw);
  }

  // Offline Caching
  Future<void> cacheData(String cacheKey, dynamic data) async {
    final raw = jsonEncode(data);
    await _prefs.setString('$_keyOfflineCachePrefix$cacheKey', raw);
  }

  dynamic getCachedData(String cacheKey) {
    final raw = _prefs.getString('$_keyOfflineCachePrefix$cacheKey');
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }
}
