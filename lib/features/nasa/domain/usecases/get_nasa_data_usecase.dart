import '../entities/nasa_entities.dart';
import '../repositories/nasa_repository.dart';

class GetNasaDataUseCase {
  final NasaRepository _repository;

  GetNasaDataUseCase(this._repository);

  Future<NasaApodEntity> getApod([String? date]) {
    return _repository.getApod(date);
  }

  Future<List<MarsPhotoEntity>> getMarsPhotos({
    String rover = 'curiosity',
    int sol = 1000,
    String? camera,
  }) {
    return _repository.getMarsPhotos(rover: rover, sol: sol, camera: camera);
  }

  Future<List<NeoAsteroidEntity>> getNearEarthObjects() {
    return _repository.getNearEarthObjects();
  }
}
