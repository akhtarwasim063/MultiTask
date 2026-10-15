import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_endpoints.dart';
import '../storage/secure_storage_service.dart';
import 'api_exceptions.dart';
import 'network_state.dart';

class ApiClient {
  late final Dio _dio;
  final SecureStorageService _storage;
  final NetworkResilienceNotifier? _resilienceNotifier;

  ApiClient(this._storage, [this._resilienceNotifier]) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'NexusHub-Dashboard/1.0.0',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          _injectApiKey(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException err, handler) {
          if (err.response?.statusCode == 429) {
            final apiName = _extractApiName(err.requestOptions.path);
            _resilienceNotifier?.triggerRateLimitBackoff(apiName, seconds: 30);
          }
          return handler.next(err);
        },
      ),
    );
  }

  void _injectApiKey(RequestOptions options) {
    final useDemo = _storage.getUseDemoKeys();
    final path = options.uri.toString();

    if (path.contains('openweathermap.org')) {
      final customKey = _storage.getWeatherApiKey();
      final key = (!useDemo && customKey != null && customKey.isNotEmpty)
          ? customKey
          : ApiEndpoints.defaultWeatherKey;
      options.queryParameters['appid'] = key;
    } else if (path.contains('newsapi.org')) {
      final customKey = _storage.getNewsApiKey();
      final key = (!useDemo && customKey != null && customKey.isNotEmpty)
          ? customKey
          : ApiEndpoints.defaultNewsApiKey;
      if (key != 'demo_mode') {
        options.headers['X-Api-Key'] = key;
      }
    } else if (path.contains('api.nasa.gov')) {
      final customKey = _storage.getNasaApiKey();
      final key = (!useDemo && customKey != null && customKey.isNotEmpty)
          ? customKey
          : ApiEndpoints.defaultNasaKey;
      options.queryParameters['api_key'] = key;
    } else if (path.contains('api.github.com')) {
      final customToken = _storage.getGitHubToken();
      if (!useDemo && customToken != null && customToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $customToken';
      }
    }
  }

  String _extractApiName(String path) {
    if (path.contains('openweathermap')) return 'OpenWeatherMap';
    if (path.contains('newsapi')) return 'NewsAPI';
    if (path.contains('nasa.gov')) return 'NASA';
    if (path.contains('github.com')) return 'GitHub';
    if (path.contains('restcountries')) return 'REST Countries';
    if (path.contains('jokeapi')) return 'JokeAPI';
    return 'Public API';
  }

  /// Robust GET with retry, offline cache, and mock fallback
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    String? cacheKey,
    dynamic fallbackData,
    int retries = 2,
  }) async {
    // If rate limit backoff is active for this API, return cache or fallback immediately
    final apiName = _extractApiName(url);
    if (_resilienceNotifier != null &&
        _resilienceNotifier.isBackoffActive &&
        _resilienceNotifier.activeApiName == apiName) {
      if (cacheKey != null) {
        final cached = _storage.getCachedData(cacheKey);
        if (cached != null) return cached;
      }
      if (fallbackData != null) return fallbackData;
      throw RateLimitException(
        'Rate limit backoff active for $apiName',
        _resilienceNotifier.countdownSeconds,
      );
    }

    int attempts = 0;
    while (attempts <= retries) {
      try {
        final response = await _dio.get(url, queryParameters: queryParameters);
        if (cacheKey != null && response.data != null) {
          await _storage.cacheData(cacheKey, response.data);
        }
        return response.data;
      } on DioException catch (dioErr) {
        attempts++;
        if (dioErr.response?.statusCode == 429) {
          _resilienceNotifier?.triggerRateLimitBackoff(apiName, seconds: 30);
          if (cacheKey != null) {
            final cached = _storage.getCachedData(cacheKey);
            if (cached != null) return cached;
          }
          if (fallbackData != null) return fallbackData;
          throw RateLimitException(
            'Rate limit (429) encountered for $apiName. Backoff active.',
            30,
          );
        }

        if (attempts > retries || dioErr.type == DioExceptionType.badResponse) {
          debugPrint('Network error fetching $url: ${dioErr.message}. Attempting cache/fallback.');
          if (cacheKey != null) {
            final cached = _storage.getCachedData(cacheKey);
            if (cached != null) return cached;
          }
          if (fallbackData != null) return fallbackData;

          if (dioErr.response?.statusCode == 401 || dioErr.response?.statusCode == 403) {
            throw const UnauthorizedException('API Authorization failed or key expired.');
          }
          throw AppException(
            dioErr.message ?? 'Network connection failed',
            dioErr.response?.statusCode,
          );
        }

        // Exponential backoff wait before retry
        await Future.delayed(Duration(milliseconds: 300 * attempts));
      } catch (e) {
        if (cacheKey != null) {
          final cached = _storage.getCachedData(cacheKey);
          if (cached != null) return cached;
        }
        if (fallbackData != null) return fallbackData;
        rethrow;
      }
    }

    if (cacheKey != null) {
      final cached = _storage.getCachedData(cacheKey);
      if (cached != null) return cached;
    }
    if (fallbackData != null) return fallbackData;
    throw const AppException('Request failed after retries');
  }
}
