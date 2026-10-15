import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/joke_entity.dart';
import '../../domain/repositories/jokes_repository.dart';
import '../datasources/jokes_remote_datasource.dart';
import '../models/joke_model.dart';

class JokesRepositoryImpl implements JokesRepository {
  final JokesRemoteDataSource _remoteDataSource;
  final SecureStorageService _storage;

  JokesRepositoryImpl(this._remoteDataSource, this._storage);

  @override
  Future<JokeEntity> getRandomJoke({
    String category = 'Programming',
    bool safeMode = true,
  }) {
    return _remoteDataSource.fetchRandomJoke(category: category, safeMode: safeMode);
  }

  @override
  List<JokeEntity> getFavoriteJokes() {
    final rawList = _storage.getFavoriteJokes();
    return rawList.map((j) => JokeModel.fromJson(j)).toList();
  }

  @override
  Future<void> toggleFavoriteJoke(JokeEntity joke) async {
    final current = _storage.getFavoriteJokes();
    final index = current.indexWhere((j) => j['id'] == joke.id);

    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add({
        'id': joke.id,
        'category': joke.category,
        'type': joke.type,
        'joke': joke.joke,
        'setup': joke.setup,
        'delivery': joke.delivery,
        'isSafe': joke.isSafe,
      });
    }

    await _storage.saveFavoriteJokes(current);
  }
}
