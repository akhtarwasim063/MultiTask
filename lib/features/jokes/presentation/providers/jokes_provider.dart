import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/state_view.dart';
import '../../data/datasources/jokes_remote_datasource.dart';
import '../../data/repositories/jokes_repository_impl.dart';
import '../../domain/entities/joke_entity.dart';
import '../../domain/repositories/jokes_repository.dart';
import '../../domain/usecases/get_joke_usecase.dart';

final jokesRemoteDataSourceProvider = Provider<JokesRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return JokesRemoteDataSourceImpl(client);
});

final jokesRepositoryProvider = Provider<JokesRepository>((ref) {
  final ds = ref.watch(jokesRemoteDataSourceProvider);
  final storage = ref.watch(storageServiceProvider);
  return JokesRepositoryImpl(ds, storage);
});

final getJokeUseCaseProvider = Provider<GetJokeUseCase>((ref) {
  final repo = ref.watch(jokesRepositoryProvider);
  return GetJokeUseCase(repo);
});

class JokesState {
  final UiState<JokeEntity> currentJokeState;
  final String activeCategory;
  final bool safeMode;
  final bool isPunchlineRevealed;
  final List<JokeEntity> favoriteJokes;

  const JokesState({
    required this.currentJokeState,
    this.activeCategory = 'Programming',
    this.safeMode = true,
    this.isPunchlineRevealed = false,
    this.favoriteJokes = const [],
  });

  bool isFavorite(int id) => favoriteJokes.any((j) => j.id == id);

  JokesState copyWith({
    UiState<JokeEntity>? currentJokeState,
    String? activeCategory,
    bool? safeMode,
    bool? isPunchlineRevealed,
    List<JokeEntity>? favoriteJokes,
  }) {
    return JokesState(
      currentJokeState: currentJokeState ?? this.currentJokeState,
      activeCategory: activeCategory ?? this.activeCategory,
      safeMode: safeMode ?? this.safeMode,
      isPunchlineRevealed: isPunchlineRevealed ?? this.isPunchlineRevealed,
      favoriteJokes: favoriteJokes ?? this.favoriteJokes,
    );
  }
}

class JokesNotifier extends StateNotifier<JokesState> {
  final GetJokeUseCase _useCase;

  JokesNotifier(this._useCase)
      : super(const JokesState(currentJokeState: InitialState())) {
    loadFavorites();
    fetchJoke();
  }

  void loadFavorites() {
    final favs = _useCase.getFavorites();
    state = state.copyWith(favoriteJokes: favs);
  }

  Future<void> fetchJoke() async {
    state = state.copyWith(
      currentJokeState: const LoadingState(),
      isPunchlineRevealed: false,
    );

    try {
      final joke = await _useCase.getRandomJoke(
        category: state.activeCategory,
        safeMode: state.safeMode,
      );
      state = state.copyWith(currentJokeState: SuccessState(joke));
    } catch (e) {
      state = state.copyWith(currentJokeState: ErrorState(e.toString()));
    }
  }

  void setCategory(String category) {
    state = state.copyWith(activeCategory: category);
    fetchJoke();
  }

  void toggleSafeMode(bool value) {
    state = state.copyWith(safeMode: value);
    fetchJoke();
  }

  void revealPunchline() {
    state = state.copyWith(isPunchlineRevealed: true);
  }

  Future<void> toggleFavorite(JokeEntity joke) async {
    await _useCase.toggleFavorite(joke);
    loadFavorites();
  }
}

final jokesProvider = StateNotifierProvider<JokesNotifier, JokesState>((ref) {
  final useCase = ref.watch(getJokeUseCaseProvider);
  return JokesNotifier(useCase);
});
