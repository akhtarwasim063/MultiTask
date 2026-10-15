import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/demo_data.dart';
import '../../../../core/network/api_client.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> fetchWeather(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiClient _client;

  WeatherRemoteDataSourceImpl(this._client);

  @override
  Future<WeatherModel> fetchWeather(String city) async {
    final query = city.trim().isEmpty ? 'London' : city.trim();

    // Fetch Current Weather
    dynamic currentData;
    try {
      currentData = await _client.get(
        '${ApiEndpoints.openWeatherBase}/weather',
        queryParameters: {
          'q': query,
          'units': 'metric',
        },
        cacheKey: 'weather_current_$query',
        fallbackData: DemoData.weatherSample,
      );
    } catch (_) {
      currentData = DemoData.weatherSample;
    }

    // Fetch 5-Day / 3-Hour Forecast
    List<dynamic> forecastList = [];
    try {
      final forecastResponse = await _client.get(
        '${ApiEndpoints.openWeatherBase}/forecast',
        queryParameters: {
          'q': query,
          'units': 'metric',
        },
        cacheKey: 'weather_forecast_$query',
        fallbackData: {'list': DemoData.weatherForecastSample},
      );
      if (forecastResponse is Map && forecastResponse['list'] is List) {
        forecastList = forecastResponse['list'];
      }
    } catch (_) {
      forecastList = DemoData.weatherForecastSample;
    }

    return WeatherModel.fromJson(
      currentData is Map<String, dynamic> ? currentData : DemoData.weatherSample,
      forecastList,
    );
  }
}
