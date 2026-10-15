import '../entities/custom_widget_entity.dart';

abstract class CustomWidgetsRepository {
  List<CustomWidgetEntity> getWidgets();
  Future<void> saveWidgets(List<CustomWidgetEntity> widgets);
  Future<void> addWidget(CustomWidgetEntity widget);
  Future<void> deleteWidget(String id);
  Future<void> reorderWidgets(int oldIndex, int newIndex);
}
