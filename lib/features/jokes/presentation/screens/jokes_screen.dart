import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/state_view.dart';
import '../../domain/entities/joke_entity.dart';
import '../providers/jokes_provider.dart';

class JokesScreen extends ConsumerWidget {
  final bool showAppBar;

  const JokesScreen({
    super.key,
    this.showAppBar = true,
  });

  final List<String> _categories = const ['Programming', 'General', 'Pun'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jokesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final safeModeToggle = IconButton(
      tooltip: '${context.tr('safe_mode')}: ${state.safeMode ? "ON" : "OFF"}',
      icon: Icon(
        state.safeMode ? Icons.shield_rounded : Icons.shield_outlined,
        color: state.safeMode ? Colors.greenAccent : Colors.grey,
      ),
      onPressed: () => ref.read(jokesProvider.notifier).toggleSafeMode(!state.safeMode),
    );

    final body = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Chips & Safe Mode Indicator
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = state.activeCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (_) => ref.read(jokesProvider.notifier).setCategory(cat),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (!showAppBar) ...[
                const SizedBox(width: 8),
                safeModeToggle,
              ],
            ],
          ),
          const SizedBox(height: 18),

          // Active Joke Display
          StateView<JokeEntity>(
            state: state.currentJokeState,
            loadingHeight: 220,
            onRetry: () => ref.read(jokesProvider.notifier).fetchJoke(),
            onSuccess: (context, joke) {
              final isFav = state.isFavorite(joke.id);

              return GlassContainer(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Badge & Favorite Heart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            joke.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFav ? Colors.redAccent : Colors.grey,
                          ),
                          onPressed: () => ref.read(jokesProvider.notifier).toggleFavorite(joke),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Joke Content
                    if (!joke.isTwoPart) ...[
                      Text(
                        joke.joke ?? 'No punchline found.',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                    ] else ...[
                      // Setup
                      Text(
                        joke.setup ?? '',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Delivery reveal
                      if (!state.isPunchlineRevealed)
                        ElevatedButton.icon(
                          onPressed: () => ref.read(jokesProvider.notifier).revealPunchline(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.secondary.withValues(alpha: 0.2),
                            foregroundColor: colorScheme.secondary,
                            side: BorderSide(color: colorScheme.secondary.withValues(alpha: 0.4)),
                          ),
                          icon: const Icon(Icons.touch_app_rounded, size: 18),
                          label: Text(context.tr('tap_reveal')),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.sentiment_very_satisfied_rounded,
                                  color: Colors.amberAccent, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  joke.delivery ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onSurface,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                    const SizedBox(height: 22),

                    // Next Laugh Button
                    ElevatedButton.icon(
                      onPressed: () => ref.read(jokesProvider.notifier).fetchJoke(),
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: Text(context.tr('next_joke')),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 26),

          // Saved Favorites Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.bookmarks_rounded, size: 20, color: Colors.amberAccent),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('saved_favorites'),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Text(
                '${state.favoriteJokes.length}',
                style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (state.favoriteJokes.isEmpty)
            GlassContainer(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  context.tr('no_favs'),
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.favoriteJokes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final fav = state.favoriteJokes[i];
                return GlassContainer(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fav.isTwoPart ? (fav.setup ?? '') : (fav.joke ?? ''),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            if (fav.isTwoPart && fav.delivery != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                fav.delivery!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                        onPressed: () => ref.read(jokesProvider.notifier).toggleFavorite(fav),
                      ),
                    ],
                  ),
                );
              },
            ),
          SizedBox(
            height: MediaQuery.of(context).size.width >= 850
                ? 24.0
                : (115.0 + MediaQuery.paddingOf(context).bottom),
          ),
        ],
      ),
    );

    if (!showAppBar) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('break_room')),
        actions: [
          safeModeToggle,
          const SizedBox(width: 8),
        ],
      ),
      body: body,
    );
  }
}
