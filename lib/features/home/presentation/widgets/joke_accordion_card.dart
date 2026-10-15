import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../jokes/domain/entities/joke_entity.dart';
import '../../../jokes/presentation/providers/jokes_provider.dart';

class JokeAccordionCard extends ConsumerWidget {
  const JokeAccordionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jokesState = ref.watch(jokesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StateView<JokeEntity>(
      state: jokesState.currentJokeState,
      loadingHeight: 120,
      onRetry: () => ref.read(jokesProvider.notifier).fetchJoke(),
      onSuccess: (context, joke) {
        return GlassContainer(
          padding: const EdgeInsets.all(16),
          onTap: () {
            ref.read(selectedNavigationIndexProvider.notifier).state = 6; // Jokes tab
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.mood_rounded, color: Colors.amberAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        context.tr('daily_laugh'),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      joke.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                joke.isTwoPart ? (joke.setup ?? '') : (joke.joke ?? ''),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.4),
              ),
              if (joke.isTwoPart && joke.delivery != null) ...[
                const SizedBox(height: 6),
                Text(
                  joke.delivery!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
