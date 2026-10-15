import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../network/network_state.dart';
import '../storage/secure_storage_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

final storageServiceProvider = Provider<SecureStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SecureStorageService(prefs);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final resilienceNotifier = ref.watch(networkResilienceProvider.notifier);
  return ApiClient(storage, resilienceNotifier);
});
