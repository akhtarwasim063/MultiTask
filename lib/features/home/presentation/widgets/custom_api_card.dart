import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../domain/entities/custom_widget_entity.dart';

class CustomApiCard extends StatelessWidget {
  final CustomWidgetEntity widgetEntity;
  final VoidCallback? onDelete;

  const CustomApiCard({
    super.key,
    required this.widgetEntity,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final url = widgetEntity.config['url']?.toString() ?? 'https://api.github.com/zen';
    final note = widgetEntity.config['note']?.toString() ?? 'Live custom payload card.';

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
                  Icon(Icons.api_rounded, color: colorScheme.secondary, size: 20),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              url,
              style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: colorScheme.primary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            note,
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}
