import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/state_view.dart';
import '../../domain/entities/news_article_entity.dart';
import '../providers/news_provider.dart';
import 'news_article_viewer.dart';

class NewsScreen extends ConsumerStatefulWidget {
  final bool showAppBar;

  const NewsScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  final List<String> _categories = [
    'technology',
    'business',
    'science',
    'general',
    'entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final cat = _categories[_tabController.index];
        _searchController.clear();
        ref.read(newsProvider.notifier).fetchHeadlines(cat);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(newsProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final categoryLabels = [
      context.tr('category_tech'),
      context.tr('category_biz'),
      context.tr('category_sci'),
      context.tr('category_gen'),
      context.tr('category_ent'),
    ];

    final tabBarWidget = TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicatorColor: colorScheme.primary,
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      tabs: categoryLabels.map((label) => Tab(text: label)).toList(),
    );

    final body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          if (!widget.showAppBar) ...[
            const SizedBox(height: 8),
            tabBarWidget,
            const SizedBox(height: 8),
          ] else ...[
            const SizedBox(height: 12),
          ],
          // Search Input with Debounce
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: context.tr('search_news'),
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(newsProvider.notifier).fetchHeadlines(state.activeCategory);
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 14),

          // News Feed
          Expanded(
            child: StateView<List<NewsArticleEntity>>(
              state: state.articlesState,
              onRetry: () => ref.read(newsProvider.notifier).fetchHeadlines(state.activeCategory),
              onSuccess: (context, articles) {
                return ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width >= 850
                        ? 24.0
                        : (115.0 + MediaQuery.paddingOf(context).bottom),
                  ),
                  itemCount: articles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (ctx, index) {
                    final article = articles[index];
                    return GlassContainer(
                      padding: const EdgeInsets.all(14),
                      onTap: () => NewsArticleViewerModal.show(context, article),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Card Image Banner
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                article.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: Colors.grey[850],
                                  child: const Center(
                                    child: Icon(Icons.broken_image_rounded, size: 36, color: Colors.white30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Meta Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  article.sourceName,
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('MMM d • HH:mm').format(article.publishedAt),
                                style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Title
                          Text(
                            article.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Short description
                          Text(
                            article.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );

    if (!widget.showAppBar) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('global_dispatch')),
        bottom: tabBarWidget,
      ),
      body: body,
    );
  }
}
