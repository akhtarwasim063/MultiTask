class WeatherForecastItem {
  final DateTime dateTime;
  final double temp;
  final int humidity;
  final int pressure;
  final String description;
  final String icon;

  const WeatherForecastItem({
    required this.dateTime,
    required this.temp,
    required this.humidity,
    required this.pressure,
    required this.description,
    required this.icon,
  });
}

class WeatherEntity {
  final String cityName;
  final String country;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String mainCondition;
  final String description;
  final String icon;
  final DateTime updatedAt;
  final List<WeatherForecastItem> forecast;

  const WeatherEntity({
    required this.cityName,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.updatedAt,
    this.forecast = const [],
  });
}
