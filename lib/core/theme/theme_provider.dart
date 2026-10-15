import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_service.dart';
import 'app_colors.dart';

class ThemeState {
  final ThemeMode themeMode;
  final int paletteIndex;
  final bool isFrostedGlassEnabled;

  const ThemeState({
    required this.themeMode,
    required this.paletteIndex,
    this.isFrostedGlassEnabled = true,
  });

  ThemePalette get currentPalette => AppPalettes.getPalette(paletteIndex);

  ThemeState copyWith({
    ThemeMode? themeMode,
    int? paletteIndex,
    bool? isFrostedGlassEnabled,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      paletteIndex: paletteIndex ?? this.paletteIndex,
      isFrostedGlassEnabled: isFrostedGlassEnabled ?? this.isFrostedGlassEnabled,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  final SecureStorageService _storage;

  ThemeNotifier(this._storage)
      : super(ThemeState(
          themeMode: _parseThemeMode(_storage.getThemeMode()),
          paletteIndex: _storage.getThemePaletteIndex(),
          isFrostedGlassEnabled: _storage.getFrostedGlassEnabled(),
        ));

  static ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.dark; // Default to dark for rich cyber dashboard aesthetic
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    final str = mode == ThemeMode.light ? 'light' : 'dark';
    _storage.setThemeMode(str);
  }

  void setPalette(int index) {
    state = state.copyWith(paletteIndex: index);
    _storage.setThemePaletteIndex(index);
    if (AppPalettes.getPalette(index).id == 'matte_black') {
      setThemeMode(ThemeMode.dark);
    }
  }

  void toggleFrostedGlass(bool enabled) {
    state = state.copyWith(isFrostedGlassEnabled: enabled);
    _storage.setFrostedGlassEnabled(enabled);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  throw UnimplementedError('themeProvider must be initialized with storage');
});
