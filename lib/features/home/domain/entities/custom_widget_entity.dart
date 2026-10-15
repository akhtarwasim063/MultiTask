enum CustomWidgetType {
  weatherGlance,
  apodHero,
  newsTicker,
  dailyLaugh,
  customApiCard,
  countryFact,
  quickNote,
}

class CustomWidgetEntity {
  final String id;
  final String title;
  final CustomWidgetType type;
  final Map<String, dynamic> config;
  final bool isVisible;
  final int orderIndex;

  const CustomWidgetEntity({
    required this.id,
    required this.title,
    required this.type,
    this.config = const {},
    this.isVisible = true,
    this.orderIndex = 0,
  });

  CustomWidgetEntity copyWith({
    String? id,
    String? title,
    CustomWidgetType? type,
    Map<String, dynamic>? config,
    bool? isVisible,
    int? orderIndex,
  }) {
    return CustomWidgetEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      config: config ?? this.config,
      isVisible: isVisible ?? this.isVisible,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
