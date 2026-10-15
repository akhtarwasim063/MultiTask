import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remoteDataSource;

  WeatherRepositoryImpl(this._remoteDataSource);

  @override
  Future<WeatherEntity> getWeather(String city) {
    return _remoteDataSource.fetchWeather(city);
  }
}
