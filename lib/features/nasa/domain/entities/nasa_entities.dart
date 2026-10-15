class NasaApodEntity {
  final String date;
  final String title;
  final String explanation;
  final String url;
  final String hdUrl;
  final String mediaType;

  const NasaApodEntity({
    required this.date,
    required this.title,
    required this.explanation,
    required this.url,
    required this.hdUrl,
    required this.mediaType,
  });
}

class MarsPhotoEntity {
  final int id;
  final int sol;
  final String cameraName;
  final String cameraFullName;
  final String imgSrc;
  final String earthDate;
  final String roverName;

  const MarsPhotoEntity({
    required this.id,
    required this.sol,
    required this.cameraName,
    required this.cameraFullName,
    required this.imgSrc,
    required this.earthDate,
    required this.roverName,
  });
}

class NeoAsteroidEntity {
  final String id;
  final String name;
  final double absoluteMagnitude;
  final double estimatedDiameterMinKm;
  final double estimatedDiameterMaxKm;
  final bool isPotentiallyHazardous;
  final String closeApproachDate;
  final String relativeVelocityKmh;
  final String missDistanceKm;
  final String missDistanceAu;

  const NeoAsteroidEntity({
    required this.id,
    required this.name,
    required this.absoluteMagnitude,
    required this.estimatedDiameterMinKm,
    required this.estimatedDiameterMaxKm,
    required this.isPotentiallyHazardous,
    required this.closeApproachDate,
    required this.relativeVelocityKmh,
    required this.missDistanceKm,
    required this.missDistanceAu,
  });
}
