import '../../domain/entities/custom_widget_entity.dart';

class CustomWidgetModel extends CustomWidgetEntity {
  const CustomWidgetModel({
    required super.id,
    required super.title,
    required super.type,
    super.config,
    super.isVisible,
    super.orderIndex,
  });

  factory CustomWidgetModel.fromJson(Map<String, dynamic> json) {
    CustomWidgetType type = CustomWidgetType.weatherGlance;
    final typeStr = json['type']?.toString();
    for (final t in CustomWidgetType.values) {
      if (t.name == typeStr) {
        type = t;
        break;
      }
    }

    return CustomWidgetModel(
      id: json['id']?.toString() ?? 'w_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title']?.toString() ?? 'Custom Widget',
      type: type,
      config: (json['config'] as Map<String, dynamic>?) ?? {},
      isVisible: json['isVisible'] != false,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.name,
        'config': config,
        'isVisible': isVisible,
        'orderIndex': orderIndex,
      };

  static List<CustomWidgetEntity> defaultDashboardWidgets() => const [
        CustomWidgetEntity(
          id: 'def_weather',
          title: 'Local Weather Glance',
          type: CustomWidgetType.weatherGlance,
          orderIndex: 0,
        ),
        CustomWidgetEntity(
          id: 'def_apod',
          title: 'NASA APOD Spotlight',
          type: CustomWidgetType.apodHero,
          orderIndex: 1,
        ),
        CustomWidgetEntity(
          id: 'def_news',
          title: 'Trending Headlines Ticker',
          type: CustomWidgetType.newsTicker,
          orderIndex: 2,
        ),
        CustomWidgetEntity(
          id: 'def_laugh',
          title: 'Daily Dev Laugh',
          type: CustomWidgetType.dailyLaugh,
          orderIndex: 3,
        ),
      ];
}
