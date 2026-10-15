import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/custom_widget_entity.dart';
import '../../domain/repositories/custom_widgets_repository.dart';
import '../models/custom_widget_model.dart';

class CustomWidgetsRepositoryImpl implements CustomWidgetsRepository {
  final SecureStorageService _storage;

  CustomWidgetsRepositoryImpl(this._storage);

  @override
  List<CustomWidgetEntity> getWidgets() {
    final rawList = _storage.getCustomWidgets();
    if (rawList.isEmpty) {
      return List<CustomWidgetEntity>.from(CustomWidgetModel.defaultDashboardWidgets());
    }
    return rawList.map((j) => CustomWidgetModel.fromJson(j)).toList();
  }

  @override
  Future<void> saveWidgets(List<CustomWidgetEntity> widgets) async {
    final jsonList = widgets.map((w) {
      if (w is CustomWidgetModel) return w.toJson();
      return {
        'id': w.id,
        'title': w.title,
        'type': w.type.name,
        'config': w.config,
        'isVisible': w.isVisible,
        'orderIndex': w.orderIndex,
      };
    }).toList();

    await _storage.saveCustomWidgets(jsonList);
  }

  @override
  Future<void> addWidget(CustomWidgetEntity widget) async {
    final list = getWidgets();
    list.add(widget);
    await saveWidgets(list);
  }

  @override
  Future<void> deleteWidget(String id) async {
    final list = getWidgets();
    list.removeWhere((w) => w.id == id);
    await saveWidgets(list);
  }

  @override
  Future<void> reorderWidgets(int oldIndex, int newIndex) async {
    final list = getWidgets();
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    await saveWidgets(list);
  }
}
