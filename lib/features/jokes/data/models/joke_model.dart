import '../../domain/entities/joke_entity.dart';

class JokeModel extends JokeEntity {
  const JokeModel({
    required super.id,
    required super.category,
    required super.type,
    super.joke,
    super.setup,
    super.delivery,
    super.isSafe,
  });

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    final flags = json['flags'] as Map<String, dynamic>? ?? {};
    final isExplicit = flags['nsfw'] == true || flags['explicit'] == true;

    return JokeModel(
      id: (json['id'] as num?)?.toInt() ?? 101,
      category: json['category']?.toString() ?? 'Programming',
      type: json['type']?.toString() ?? 'twopart',
      joke: json['joke']?.toString(),
      setup: json['setup']?.toString(),
      delivery: json['delivery']?.toString(),
      isSafe: !isExplicit,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'type': type,
        'joke': joke,
        'setup': setup,
        'delivery': delivery,
        'isSafe': isSafe,
      };
}
