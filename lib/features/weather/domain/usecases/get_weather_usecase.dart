import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository _repository;

  GetWeatherUseCase(this._repository);

  Future<WeatherEntity> call(String city) {
    return _repository.getWeather(city);
  }
}
