import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_service.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  final SecureStorageService _storage;

  LocaleNotifier(this._storage)
      : super(Locale(_storage.getLocaleCode()));

  void setLocale(String langCode) {
    state = Locale(langCode);
    _storage.setLocaleCode(langCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  throw UnimplementedError('localeProvider must be initialized with storage');
});
