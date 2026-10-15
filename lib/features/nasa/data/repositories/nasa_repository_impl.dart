import '../../domain/entities/nasa_entities.dart';
import '../../domain/repositories/nasa_repository.dart';
import '../datasources/nasa_remote_datasource.dart';

class NasaRepositoryImpl implements NasaRepository {
  final NasaRemoteDataSource _remoteDataSource;

  NasaRepositoryImpl(this._remoteDataSource);

  @override
  Future<NasaApodEntity> getApod([String? date]) {
    return _remoteDataSource.fetchApod(date);
  }

  @override
  Future<List<MarsPhotoEntity>> getMarsPhotos({
    String rover = 'curiosity',
    int sol = 1000,
    String? camera,
  }) {
    return _remoteDataSource.fetchMarsPhotos(rover: rover, sol: sol, camera: camera);
  }

  @override
  Future<List<NeoAsteroidEntity>> getNearEarthObjects() {
    return _remoteDataSource.fetchNearEarthObjects();
  }
}
