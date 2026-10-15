import '../../domain/entities/weather_entity.dart';

class WeatherForecastModel extends WeatherForecastItem {
  const WeatherForecastModel({
    required super.dateTime,
    required super.temp,
    required super.humidity,
    required super.pressure,
    required super.description,
    required super.icon,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weatherFirst = weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};

    DateTime dt;
    if (json['dt_txt'] != null) {
      dt = DateTime.tryParse(json['dt_txt'].toString()) ?? DateTime.now();
    } else if (json['dt'] != null) {
      dt = DateTime.fromMillisecondsSinceEpoch((json['dt'] as num).toInt() * 1000);
    } else {
      dt = DateTime.now();
    }

    return WeatherForecastModel(
      dateTime: dt,
      temp: (main['temp'] as num?)?.toDouble() ?? 20.0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 50,
      pressure: (main['pressure'] as num?)?.toInt() ?? 1013,
      description: weatherFirst['description']?.toString() ?? 'clear sky',
      icon: weatherFirst['icon']?.toString() ?? '01d',
    );
  }
}

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.cityName,
    required super.country,
    required super.temp,
    required super.feelsLike,
    required super.tempMin,
    required super.tempMax,
    required super.humidity,
    required super.pressure,
    required super.windSpeed,
    required super.mainCondition,
    required super.description,
    required super.icon,
    required super.updatedAt,
    super.forecast,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> currentJson, [
    List<dynamic>? forecastListJson,
  ]) {
    final main = currentJson['main'] as Map<String, dynamic>? ?? {};
    final sys = currentJson['sys'] as Map<String, dynamic>? ?? {};
    final wind = currentJson['wind'] as Map<String, dynamic>? ?? {};
    final weatherList = currentJson['weather'] as List<dynamic>? ?? [];
    final weatherFirst = weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};

    final forecasts = forecastListJson != null
        ? forecastListJson
            .map((item) => WeatherForecastModel.fromJson(item as Map<String, dynamic>))
            .toList()
        : <WeatherForecastItem>[];

    return WeatherModel(
      cityName: currentJson['name']?.toString() ?? 'London',
      country: sys['country']?.toString() ?? 'GB',
      temp: (main['temp'] as num?)?.toDouble() ?? 20.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 19.0,
      tempMin: (main['temp_min'] as num?)?.toDouble() ?? 16.0,
      tempMax: (main['temp_max'] as num?)?.toDouble() ?? 22.0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 60,
      pressure: (main['pressure'] as num?)?.toInt() ?? 1014,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 3.5,
      mainCondition: weatherFirst['main']?.toString() ?? 'Clear',
      description: weatherFirst['description']?.toString() ?? 'clear sky',
      icon: weatherFirst['icon']?.toString() ?? '01d',
      updatedAt: DateTime.now(),
      forecast: forecasts,
    );
  }
}
