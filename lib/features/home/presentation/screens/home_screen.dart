import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../../jokes/presentation/providers/jokes_provider.dart';
import '../../../nasa/presentation/providers/nasa_provider.dart';
import '../../../news/presentation/providers/news_provider.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../domain/entities/custom_widget_entity.dart';
import '../providers/custom_widgets_provider.dart';
import '../widgets/apod_hero_banner.dart';
import '../widgets/create_widget_modal.dart';
import '../widgets/custom_api_card.dart';
import '../widgets/joke_accordion_card.dart';
import '../widgets/news_ticker.dart';
import '../widgets/quick_note_card.dart';
import '../widgets/weather_glance_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _refreshAll(WidgetRef ref) {
    ref.read(weatherProvider.notifier).fetchWeather('London');
    ref.read(apodProvider.notifier).fetchApod();
    ref.read(newsProvider.notifier).fetchHeadlines('technology');
    ref.read(jokesProvider.notifier).fetchJoke();
  }

  void _navigateTo(WidgetRef ref, int index) {
    ref.read(selectedNavigationIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = ref.watch(customWidgetsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('daily_briefing')),
        actions: [
          IconButton(
            tooltip: 'Refresh All APIs',
            icon: const Icon(Icons.sync_rounded),
            onPressed: () => _refreshAll(ref),
          ),
          if (screenWidth >= 420)
            ElevatedButton.icon(
              onPressed: () {
                CreateWidgetModal.show(context, (newWidget) {
                  ref.read(customWidgetsProvider.notifier).addWidget(newWidget);
                });
              },
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text(context.tr('create_widget_btn')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
          else
            IconButton.filledTonal(
              tooltip: context.tr('create_widget_btn'),
              icon: const Icon(Icons.add_rounded, size: 20),
              onPressed: () {
                CreateWidgetModal.show(context, (newWidget) {
                  ref.read(customWidgetsProvider.notifier).addWidget(newWidget);
                });
              },
            ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Subtitle & Status Banner
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr('greeting_sub'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Categorized Quick Access Carousel
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _QuickLaunchPill(
                    icon: Icons.wb_sunny_rounded,
                    label: context.tr('nav_weather'),
                    color: Colors.amberAccent,
                    onTap: () => _navigateTo(ref, 1),
                  ),
                  const SizedBox(width: 8),
                  _QuickLaunchPill(
                    icon: Icons.public_rounded,
                    label: context.tr('nav_countries'),
                    color: Colors.blueAccent,
                    onTap: () => _navigateTo(ref, 2),
                  ),
                  const SizedBox(width: 8),
                  _QuickLaunchPill(
                    icon: Icons.newspaper_rounded,
                    label: context.tr('nav_news'),
                    color: Colors.tealAccent,
                    onTap: () => _navigateTo(ref, 3),
                  ),
                  const SizedBox(width: 8),
                  _QuickLaunchPill(
                    icon: Icons.rocket_launch_rounded,
                    label: context.tr('nav_nasa'),
                    color: Colors.purpleAccent,
                    onTap: () => _navigateTo(ref, 4),
                  ),
                  const SizedBox(width: 8),
                  _QuickLaunchPill(
                    icon: Icons.code_rounded,
                    label: context.tr('nav_github'),
                    color: Colors.cyanAccent,
                    onTap: () => _navigateTo(ref, 5),
                  ),
                  const SizedBox(width: 8),
                  _QuickLaunchPill(
                    icon: Icons.mood_rounded,
                    label: context.tr('nav_jokes'),
                    color: Colors.pinkAccent,
                    onTap: () => _navigateTo(ref, 6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // SECTION 1: REAL-TIME GLANCE
            _SectionHeader(
              title: 'Live Telemetry & Headlines',
              icon: Icons.flash_on_rounded,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 10),
            const WeatherGlanceCard(),
            const SizedBox(height: 12),
            const NewsTicker(),
            const SizedBox(height: 22),

            // SECTION 2: COSMIC HIGHLIGHT
            _SectionHeader(
              title: 'Cosmic Picture of the Day',
              icon: Icons.auto_awesome_rounded,
              color: Colors.purpleAccent,
            ),
            const SizedBox(height: 10),
            const ApodHeroBanner(),
            const SizedBox(height: 22),

            // SECTION 3: DEVELOPER LOUNGE
            _SectionHeader(
              title: 'Developer Break Room',
              icon: Icons.sentiment_very_satisfied_rounded,
              color: Colors.amberAccent,
            ),
            const SizedBox(height: 10),
            const JokeAccordionCard(),
            const SizedBox(height: 22),

            // SECTION 4: CUSTOM DASHBOARD WIDGETS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionHeader(
                  title: 'Custom Dashboard Studio',
                  icon: Icons.dashboard_customize_rounded,
                  color: colorScheme.primary,
                ),
                Text(
                  '${widgets.where((w) => w.type == CustomWidgetType.customApiCard || w.type == CustomWidgetType.quickNote).length} Active',
                  style: TextStyle(fontSize: 11, color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (!widgets.any((w) =>
                w.type == CustomWidgetType.customApiCard ||
                w.type == CustomWidgetType.quickNote)) ...[
              GlassContainer(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.dashboard_customize_outlined, size: 32, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'No Custom Cards Configured',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Add custom REST API cards or quick dev notes to your dashboard.',
                            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ...widgets
                  .where((w) =>
                      w.type == CustomWidgetType.customApiCard ||
                      w.type == CustomWidgetType.quickNote)
                  .map((widgetEntity) {
                if (widgetEntity.type == CustomWidgetType.customApiCard) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CustomApiCard(
                      widgetEntity: widgetEntity,
                      onDelete: () => ref
                          .read(customWidgetsProvider.notifier)
                          .deleteWidget(widgetEntity.id),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: QuickNoteCard(
                      widgetEntity: widgetEntity,
                      onDelete: () => ref
                          .read(customWidgetsProvider.notifier)
                          .deleteWidget(widgetEntity.id),
                    ),
                  );
                }
              }),
            ],

            SizedBox(
              height: MediaQuery.of(context).size.width >= 850
                  ? 24.0
                  : (115.0 + MediaQuery.paddingOf(context).bottom),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _QuickLaunchPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickLaunchPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
