import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../weather/domain/entities/weather_entity.dart';
import '../../../weather/presentation/providers/weather_provider.dart';

class WeatherGlanceCard extends ConsumerWidget {
  const WeatherGlanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StateView<WeatherEntity>(
      state: weatherState,
      loadingHeight: 110,
      onRetry: () => ref.read(weatherProvider.notifier).fetchWeather('London'),
      onSuccess: (context, weather) {
        return GlassContainer(
          padding: const EdgeInsets.all(18),
          onTap: () {
            ref.read(selectedNavigationIndexProvider.notifier).state = 1; // Weather tab
          },
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    weather.mainCondition.toLowerCase().contains('rain')
                        ? Icons.water_drop_rounded
                        : Icons.wb_sunny_rounded,
                    color: colorScheme.primary,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.cityName}, ${weather.country}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${weather.description.toUpperCase()} • Humidity ${weather.humidity}%',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${weather.temp.round()}°C',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
