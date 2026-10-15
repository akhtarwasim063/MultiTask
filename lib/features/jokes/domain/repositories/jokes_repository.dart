import '../entities/joke_entity.dart';

abstract class JokesRepository {
  Future<JokeEntity> getRandomJoke({
    String category = 'Programming',
    bool safeMode = true,
  });
  List<JokeEntity> getFavoriteJokes();
  Future<void> toggleFavoriteJoke(JokeEntity joke);
}
