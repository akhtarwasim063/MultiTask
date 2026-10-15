import '../../domain/entities/nasa_entities.dart';

class NasaApodModel extends NasaApodEntity {
  const NasaApodModel({
    required super.date,
    required super.title,
    required super.explanation,
    required super.url,
    required super.hdUrl,
    required super.mediaType,
  });

  factory NasaApodModel.fromJson(Map<String, dynamic> json) {
    return NasaApodModel(
      date: json['date']?.toString() ?? '2026-10-14',
      title: json['title']?.toString() ?? 'Cosmic Deep Space',
      explanation: json['explanation']?.toString() ?? 'Stellar nebula and starburst regions observed.',
      url: json['url']?.toString() ?? 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=1200',
      hdUrl: json['hdurl']?.toString() ?? json['url']?.toString() ?? '',
      mediaType: json['media_type']?.toString() ?? 'image',
    );
  }
}

class MarsPhotoModel extends MarsPhotoEntity {
  const MarsPhotoModel({
    required super.id,
    required super.sol,
    required super.cameraName,
    required super.cameraFullName,
    required super.imgSrc,
    required super.earthDate,
    required super.roverName,
  });

  factory MarsPhotoModel.fromJson(Map<String, dynamic> json) {
    final camera = json['camera'] as Map<String, dynamic>? ?? {};
    final rover = json['rover'] as Map<String, dynamic>? ?? {};

    return MarsPhotoModel(
      id: (json['id'] as num?)?.toInt() ?? 1001,
      sol: (json['sol'] as num?)?.toInt() ?? 1000,
      cameraName: camera['name']?.toString() ?? 'NAVCAM',
      cameraFullName: camera['full_name']?.toString() ?? 'Navigation Camera',
      imgSrc: json['img_src']?.toString() ??
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1000',
      earthDate: json['earth_date']?.toString() ?? '2026-05-30',
      roverName: rover['name']?.toString() ?? 'Curiosity',
    );
  }
}

class NeoAsteroidModel extends NeoAsteroidEntity {
  const NeoAsteroidModel({
    required super.id,
    required super.name,
    required super.absoluteMagnitude,
    required super.estimatedDiameterMinKm,
    required super.estimatedDiameterMaxKm,
    required super.isPotentiallyHazardous,
    required super.closeApproachDate,
    required super.relativeVelocityKmh,
    required super.missDistanceKm,
    required super.missDistanceAu,
  });

  factory NeoAsteroidModel.fromJson(Map<String, dynamic> json) {
    final estDiam = json['estimated_diameter'] as Map<String, dynamic>? ?? {};
    final kmDiam = estDiam['kilometers'] as Map<String, dynamic>? ?? {};
    final approachList = json['close_approach_data'] as List<dynamic>? ?? [];
    final firstApproach = approachList.isNotEmpty
        ? approachList[0] as Map<String, dynamic>
        : <String, dynamic>{};
    final relVel = firstApproach['relative_velocity'] as Map<String, dynamic>? ?? {};
    final missDist = firstApproach['miss_distance'] as Map<String, dynamic>? ?? {};

    return NeoAsteroidModel(
      id: json['id']?.toString() ?? '000000',
      name: json['name']?.toString() ?? 'Unknown Asteroid',
      absoluteMagnitude: (json['absolute_magnitude_h'] as num?)?.toDouble() ?? 20.0,
      estimatedDiameterMinKm: (kmDiam['estimated_diameter_min'] as num?)?.toDouble() ?? 0.05,
      estimatedDiameterMaxKm: (kmDiam['estimated_diameter_max'] as num?)?.toDouble() ?? 0.15,
      isPotentiallyHazardous: json['is_potentially_hazardous_asteroid'] == true,
      closeApproachDate: firstApproach['close_approach_date']?.toString() ?? '2026-10-18',
      relativeVelocityKmh: relVel['kilometers_per_hour']?.toString() ?? '52,400',
      missDistanceKm: missDist['kilometers']?.toString() ?? '3,200,000',
      missDistanceAu: missDist['astronomical']?.toString() ?? '0.021',
    );
  }
}
