import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/state_view.dart';
import '../../data/datasources/nasa_remote_datasource.dart';
import '../../data/repositories/nasa_repository_impl.dart';
import '../../domain/entities/nasa_entities.dart';
import '../../domain/repositories/nasa_repository.dart';
import '../../domain/usecases/get_nasa_data_usecase.dart';

final nasaRemoteDataSourceProvider = Provider<NasaRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return NasaRemoteDataSourceImpl(client);
});

final nasaRepositoryProvider = Provider<NasaRepository>((ref) {
  final ds = ref.watch(nasaRemoteDataSourceProvider);
  return NasaRepositoryImpl(ds);
});

final getNasaDataUseCaseProvider = Provider<GetNasaDataUseCase>((ref) {
  final repo = ref.watch(nasaRepositoryProvider);
  return GetNasaDataUseCase(repo);
});

// APOD Notifier
class ApodNotifier extends StateNotifier<UiState<NasaApodEntity>> {
  final GetNasaDataUseCase _useCase;
  String? _selectedDate;

  ApodNotifier(this._useCase) : super(const InitialState()) {
    fetchApod();
  }

  String? get selectedDate => _selectedDate;

  Future<void> fetchApod([String? date]) async {
    _selectedDate = date;
    state = const LoadingState();

    try {
      final apod = await _useCase.getApod(date);
      state = SuccessState(apod);
    } catch (e) {
      state = ErrorState(e.toString());
    }
  }
}

final apodProvider =
    StateNotifierProvider<ApodNotifier, UiState<NasaApodEntity>>((ref) {
  final useCase = ref.watch(getNasaDataUseCaseProvider);
  return ApodNotifier(useCase);
});

// Mars Rover Notifier
class MarsRoverState {
  final UiState<List<MarsPhotoEntity>> photosState;
  final String activeRover;
  final String? activeCamera;
  final int sol;

  const MarsRoverState({
    required this.photosState,
    this.activeRover = 'Curiosity',
    this.activeCamera,
    this.sol = 1000,
  });

  MarsRoverState copyWith({
    UiState<List<MarsPhotoEntity>>? photosState,
    String? activeRover,
    String? activeCamera,
    int? sol,
  }) {
    return MarsRoverState(
      photosState: photosState ?? this.photosState,
      activeRover: activeRover ?? this.activeRover,
      activeCamera: activeCamera ?? this.activeCamera,
      sol: sol ?? this.sol,
    );
  }
}

class MarsRoverNotifier extends StateNotifier<MarsRoverState> {
  final GetNasaDataUseCase _useCase;

  MarsRoverNotifier(this._useCase)
      : super(const MarsRoverState(photosState: InitialState())) {
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    state = state.copyWith(photosState: const LoadingState());

    try {
      final photos = await _useCase.getMarsPhotos(
        rover: state.activeRover,
        sol: state.sol,
        camera: state.activeCamera,
      );
      if (photos.isEmpty) {
        state = state.copyWith(photosState: const EmptyState('No Mars photos found for this rover/camera/sol configuration.'));
      } else {
        state = state.copyWith(photosState: SuccessState(photos));
      }
    } catch (e) {
      state = state.copyWith(photosState: ErrorState(e.toString()));
    }
  }

  void setRover(String rover) {
    state = state.copyWith(activeRover: rover);
    fetchPhotos();
  }

  void setCamera(String? camera) {
    state = state.copyWith(activeCamera: camera);
    fetchPhotos();
  }

  void setSol(int sol) {
    state = state.copyWith(sol: sol);
    fetchPhotos();
  }
}

final marsRoverProvider =
    StateNotifierProvider<MarsRoverNotifier, MarsRoverState>((ref) {
  final useCase = ref.watch(getNasaDataUseCaseProvider);
  return MarsRoverNotifier(useCase);
});

// NEO Asteroids Notifier
class NeoNotifier extends StateNotifier<UiState<List<NeoAsteroidEntity>>> {
  final GetNasaDataUseCase _useCase;

  NeoNotifier(this._useCase) : super(const InitialState()) {
    fetchNeo();
  }

  Future<void> fetchNeo() async {
    state = const LoadingState();

    try {
      final asteroids = await _useCase.getNearEarthObjects();
      if (asteroids.isEmpty) {
        state = const EmptyState('No Near-Earth Objects detected for today.');
      } else {
        state = SuccessState(asteroids);
      }
    } catch (e) {
      state = ErrorState(e.toString());
    }
  }
}

final neoProvider =
    StateNotifierProvider<NeoNotifier, UiState<List<NeoAsteroidEntity>>>((ref) {
  final useCase = ref.watch(getNasaDataUseCaseProvider);
  return NeoNotifier(useCase);
});
