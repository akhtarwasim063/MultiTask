import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../domain/entities/custom_widget_entity.dart';

class QuickNoteCard extends StatelessWidget {
  final CustomWidgetEntity widgetEntity;
  final VoidCallback? onDelete;

  const QuickNoteCard({
    super.key,
    required this.widgetEntity,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final noteContent = widgetEntity.config['content']?.toString() ??
        'Review sprint objectives & API rate limits.';

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.sticky_note_2_rounded, color: Colors.amberAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    widgetEntity.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ],
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: Colors.grey),
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            noteContent,
            style: const TextStyle(fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
