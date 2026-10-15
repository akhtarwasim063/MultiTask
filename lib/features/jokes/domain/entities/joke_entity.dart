class JokeEntity {
  final int id;
  final String category;
  final String type; // 'single' or 'twopart'
  final String? joke; // for single
  final String? setup; // for twopart
  final String? delivery; // for twopart
  final bool isSafe;

  const JokeEntity({
    required this.id,
    required this.category,
    required this.type,
    this.joke,
    this.setup,
    this.delivery,
    this.isSafe = true,
  });

  bool get isTwoPart => type == 'twopart';
}
