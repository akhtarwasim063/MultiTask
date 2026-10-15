import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/state_view.dart';
import '../../data/datasources/weather_remote_datasource.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_weather_usecase.dart';

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return WeatherRemoteDataSourceImpl(client);
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final ds = ref.watch(weatherRemoteDataSourceProvider);
  return WeatherRepositoryImpl(ds);
});

final getWeatherUseCaseProvider = Provider<GetWeatherUseCase>((ref) {
  final repo = ref.watch(weatherRepositoryProvider);
  return GetWeatherUseCase(repo);
});

class WeatherNotifier extends StateNotifier<UiState<WeatherEntity>> {
  final GetWeatherUseCase _getWeatherUseCase;
  String _currentCity = 'London';

  WeatherNotifier(this._getWeatherUseCase) : super(const InitialState()) {
    fetchWeather('London');
  }

  String get currentCity => _currentCity;

  Future<void> fetchWeather(String city) async {
    _currentCity = city.trim().isEmpty ? 'London' : city.trim();
    state = const LoadingState();

    try {
      final result = await _getWeatherUseCase(_currentCity);
      state = SuccessState(result);
    } catch (e) {
      state = ErrorState(e.toString());
    }
  }

  void detectLocation() {
    // Geolocation detection simulation / auto-detect
    fetchWeather('New York');
  }
}

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, UiState<WeatherEntity>>((ref) {
  final useCase = ref.watch(getWeatherUseCaseProvider);
  return WeatherNotifier(useCase);
});
