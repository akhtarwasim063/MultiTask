import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../nasa/domain/entities/nasa_entities.dart';
import '../../../nasa/presentation/providers/nasa_provider.dart';

class ApodHeroBanner extends ConsumerWidget {
  const ApodHeroBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apodState = ref.watch(apodProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StateView<NasaApodEntity>(
      state: apodState,
      loadingHeight: 200,
      onRetry: () => ref.read(apodProvider.notifier).fetchApod(),
      onSuccess: (context, apod) {
        return GlassContainer(
          padding: EdgeInsets.zero,
          onTap: () {
            ref.read(selectedNavigationIndexProvider.notifier).state = 4; // NASA tab
          },
          child: Stack(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    apod.url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white30),
                      ),
                    ),
                  ),
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Text Content
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'NASA APOD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          apod.date,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      apod.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      apod.explanation,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
