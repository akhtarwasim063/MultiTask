import '../entities/joke_entity.dart';
import '../repositories/jokes_repository.dart';

class GetJokeUseCase {
  final JokesRepository _repository;

  GetJokeUseCase(this._repository);

  Future<JokeEntity> getRandomJoke({String category = 'Programming', bool safeMode = true}) {
    return _repository.getRandomJoke(category: category, safeMode: safeMode);
  }

  List<JokeEntity> getFavorites() {
    return _repository.getFavoriteJokes();
  }

  Future<void> toggleFavorite(JokeEntity joke) {
    return _repository.toggleFavoriteJoke(joke);
  }
}
