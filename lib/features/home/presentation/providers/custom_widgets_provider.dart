import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../data/repositories/custom_widgets_repository_impl.dart';
import '../../domain/entities/custom_widget_entity.dart';
import '../../domain/repositories/custom_widgets_repository.dart';

final customWidgetsRepositoryProvider = Provider<CustomWidgetsRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return CustomWidgetsRepositoryImpl(storage);
});

class CustomWidgetsNotifier extends StateNotifier<List<CustomWidgetEntity>> {
  final CustomWidgetsRepository _repository;

  CustomWidgetsNotifier(this._repository) : super([]) {
    loadWidgets();
  }

  void loadWidgets() {
    state = _repository.getWidgets();
  }

  Future<void> addWidget(CustomWidgetEntity widget) async {
    await _repository.addWidget(widget);
    loadWidgets();
  }

  Future<void> deleteWidget(String id) async {
    await _repository.deleteWidget(id);
    loadWidgets();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    await _repository.reorderWidgets(oldIndex, newIndex);
    loadWidgets();
  }

  Future<void> toggleVisibility(String id) async {
    final updated = state.map((w) {
      if (w.id == id) {
        return w.copyWith(isVisible: !w.isVisible);
      }
      return w;
    }).toList();
    await _repository.saveWidgets(updated);
    state = updated;
  }
}

final customWidgetsProvider =
    StateNotifierProvider<CustomWidgetsNotifier, List<CustomWidgetEntity>>((ref) {
  final repo = ref.watch(customWidgetsRepositoryProvider);
  return CustomWidgetsNotifier(repo);
});
