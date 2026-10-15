import 'dart:math';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/demo_data.dart';
import '../../../../core/network/api_client.dart';
import '../models/joke_model.dart';

abstract class JokesRemoteDataSource {
  Future<JokeModel> fetchRandomJoke({
    String category = 'Programming',
    bool safeMode = true,
  });
}

class JokesRemoteDataSourceImpl implements JokesRemoteDataSource {
  final ApiClient _client;

  JokesRemoteDataSourceImpl(this._client);

  @override
  Future<JokeModel> fetchRandomJoke({
    String category = 'Programming',
    bool safeMode = true,
  }) async {
    final queryParams = <String, dynamic>{};
    if (safeMode) {
      queryParams['safe-mode'] = '';
    }

    try {
      final response = await _client.get(
        '${ApiEndpoints.jokeApiBase}/$category',
        queryParameters: queryParams,
        cacheKey: 'joke_latest_$category',
        fallbackData: DemoData.jokesSample[0],
      );

      if (response is Map<String, dynamic> && response['error'] != true) {
        return JokeModel.fromJson(response);
      }
    } catch (_) {}

    // Pick random from demo pool
    final random = Random();
    final item = DemoData.jokesSample[random.nextInt(DemoData.jokesSample.length)];
    return JokeModel.fromJson(item);
  }
}
