import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/demo_data.dart';
import '../../../../core/network/api_client.dart';
import '../models/nasa_models.dart';

abstract class NasaRemoteDataSource {
  Future<NasaApodModel> fetchApod([String? date]);
  Future<List<MarsPhotoModel>> fetchMarsPhotos({
    String rover = 'curiosity',
    int sol = 1000,
    String? camera,
  });
  Future<List<NeoAsteroidModel>> fetchNearEarthObjects();
}

class NasaRemoteDataSourceImpl implements NasaRemoteDataSource {
  final ApiClient _client;

  NasaRemoteDataSourceImpl(this._client);

  @override
  Future<NasaApodModel> fetchApod([String? date]) async {
    final params = <String, dynamic>{};
    if (date != null && date.isNotEmpty) {
      params['date'] = date;
    }

    try {
      final response = await _client.get(
        '${ApiEndpoints.nasaBase}/planetary/apod',
        queryParameters: params,
        cacheKey: 'nasa_apod_${date ?? 'today'}',
        fallbackData: DemoData.nasaApodSample,
      );

      if (response is Map<String, dynamic>) {
        return NasaApodModel.fromJson(response);
      }
    } catch (_) {}

    return NasaApodModel.fromJson(DemoData.nasaApodSample);
  }

  @override
  Future<List<MarsPhotoModel>> fetchMarsPhotos({
    String rover = 'curiosity',
    int sol = 1000,
    String? camera,
  }) async {
    final params = <String, dynamic>{'sol': sol};
    if (camera != null && camera.isNotEmpty && camera.toLowerCase() != 'all') {
      params['camera'] = camera.toLowerCase();
    }

    try {
      final response = await _client.get(
        '${ApiEndpoints.nasaBase}/mars-photos/api/v1/rovers/${rover.toLowerCase()}/photos',
        queryParameters: params,
        cacheKey: 'nasa_mars_${rover}_${sol}_$camera',
        fallbackData: {'photos': DemoData.nasaMarsRoverSample},
      );

      if (response is Map && response['photos'] is List) {
        return (response['photos'] as List)
            .map((item) => MarsPhotoModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    return DemoData.nasaMarsRoverSample
        .map((item) => MarsPhotoModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<NeoAsteroidModel>> fetchNearEarthObjects() async {
    try {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final response = await _client.get(
        '${ApiEndpoints.nasaBase}/neo/rest/v1/feed',
        queryParameters: {
          'start_date': today,
          'end_date': today,
        },
        cacheKey: 'nasa_neo_$today',
        fallbackData: {'near_earth_objects': {today: DemoData.nasaNeoSample}},
      );

      if (response is Map && response['near_earth_objects'] is Map) {
        final neoMap = response['near_earth_objects'] as Map<String, dynamic>;
        final allAsteroids = <NeoAsteroidModel>[];
        for (final list in neoMap.values) {
          if (list is List) {
            allAsteroids.addAll(list.map((item) => NeoAsteroidModel.fromJson(item as Map<String, dynamic>)));
          }
        }
        if (allAsteroids.isNotEmpty) return allAsteroids;
      }
    } catch (_) {}

    return DemoData.nasaNeoSample
        .map((item) => NeoAsteroidModel.fromJson(item))
        .toList();
  }
}
