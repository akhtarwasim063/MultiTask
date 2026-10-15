import '../entities/nasa_entities.dart';

abstract class NasaRepository {
  Future<NasaApodEntity> getApod([String? date]);
  Future<List<MarsPhotoEntity>> getMarsPhotos({
    String rover = 'curiosity',
    int sol = 1000,
    String? camera,
  });
  Future<List<NeoAsteroidEntity>> getNearEarthObjects();
}
