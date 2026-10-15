import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../news/domain/entities/news_article_entity.dart';
import '../../../news/presentation/providers/news_provider.dart';

class NewsTicker extends ConsumerWidget {
  const NewsTicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StateView<List<NewsArticleEntity>>(
      state: newsState.articlesState,
      loadingHeight: 140,
      onRetry: () => ref.read(newsProvider.notifier).fetchHeadlines('technology'),
      onSuccess: (context, articles) {
        final top3 = articles.take(3).toList();

        return GlassContainer(
          padding: const EdgeInsets.all(16),
          onTap: () {
            ref.read(selectedNavigationIndexProvider.notifier).state = 3; // News tab
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up_rounded, color: colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        context.tr('trending_news'),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              ...top3.map((article) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          article.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
