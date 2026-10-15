import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/state_view.dart';
import '../../domain/entities/weather_entity.dart';
import '../providers/weather_provider.dart';
import '../widgets/forecast_chart.dart';
import '../widgets/weather_metric_gauge.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  final bool showAppBar;

  const WeatherScreen({super.key, this.showAppBar = true});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _popularCities = ['London', 'Tokyo', 'New York', 'Paris', 'Dubai', 'Sydney'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(weatherProvider.notifier).fetchWeather(query);
    }
  }

  void _triggerGps() {
    ref.read(weatherProvider.notifier).detectLocation();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulating GPS Location Detection: New York'), duration: Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final body = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _onSearch(),
                  decoration: InputDecoration(
                    hintText: context.tr('search_city_hint'),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) => setState(() {}),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _onSearch,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Icon(Icons.arrow_forward_rounded, size: 20),
              ),
              if (!widget.showAppBar) ...[
                const SizedBox(width: 8),
                IconButton.filledTonal(tooltip: 'Auto-detect Location', icon: const Icon(Icons.my_location_rounded, size: 20), onPressed: _triggerGps),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Popular City Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _popularCities.map((city) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    label: Text(city),
                    avatar: const Icon(Icons.location_city_rounded, size: 16),
                    onPressed: () {
                      _searchController.text = city;
                      ref.read(weatherProvider.notifier).fetchWeather(city);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // Weather Content with Explicit StateView
          StateView<WeatherEntity>(
            state: weatherState,
            onRetry: () => ref.read(weatherProvider.notifier).fetchWeather(ref.read(weatherProvider.notifier).currentCity),
            onSuccess: (context, weather) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Weather Banner
                  GlassContainer(
                    padding: const EdgeInsets.all(22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on_rounded, size: 18, color: Colors.redAccent),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${weather.cityName}, ${weather.country}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text('${weather.temp.round()}°C', style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w900, letterSpacing: -2, height: 1.0)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                weather.description.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary, letterSpacing: 1.2),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'H: ${weather.tempMax.round()}° • L: ${weather.tempMin.round()}° • ${context.tr('feels_like')}: ${weather.feelsLike.round()}°',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(gradient: RadialGradient(colors: [colorScheme.primary.withValues(alpha: 0.3), Colors.transparent])),
                          child: Icon(
                            weather.mainCondition.toLowerCase().contains('cloud')
                                ? Icons.cloud_queue_rounded
                                : (weather.mainCondition.toLowerCase().contains('rain') ? Icons.grain_rounded : Icons.wb_sunny_rounded),
                            size: 56,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Metrics Gauges Grid (Responsive childAspectRatio)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 720;
                      final isMedium = constraints.maxWidth >= 480;
                      final count = isWide ? 4 : (isMedium ? 3 : 2);
                      final aspect = isWide ? 1.35 : (isMedium ? 1.25 : 1.15);

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: count,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: aspect,
                        children: [
                          WeatherMetricGauge(
                            icon: Icons.water_drop_rounded,
                            label: context.tr('humidity'),
                            value: '${weather.humidity}%',
                            accentColor: Colors.blueAccent,
                            progress: weather.humidity / 100.0,
                          ),
                          WeatherMetricGauge(
                            icon: Icons.speed_rounded,
                            label: context.tr('pressure'),
                            value: '${weather.pressure} hPa',
                            accentColor: Colors.amberAccent,
                            progress: ((weather.pressure - 950) / 100.0).clamp(0.0, 1.0),
                          ),
                          WeatherMetricGauge(
                            icon: Icons.air_rounded,
                            label: context.tr('wind_speed'),
                            value: '${weather.windSpeed} m/s',
                            accentColor: Colors.tealAccent,
                            progress: (weather.windSpeed / 20.0).clamp(0.0, 1.0),
                          ),
                          WeatherMetricGauge(
                            icon: Icons.thermostat_rounded,
                            label: context.tr('feels_like'),
                            value: '${weather.feelsLike.round()}°C',
                            accentColor: Colors.deepOrangeAccent,
                            progress: ((weather.feelsLike + 10) / 50.0).clamp(0.0, 1.0),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 5-Day / 3-Hour Forecast Visual Chart
                  ForecastChart(forecast: weather.forecast),
                  SizedBox(height: MediaQuery.of(context).size.width >= 850 ? 24.0 : (115.0 + MediaQuery.paddingOf(context).bottom)),
                ],
              );
            },
          ),
        ],
      ),
    );

    if (!widget.showAppBar) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('weather_desk')),
        actions: [
          IconButton(tooltip: 'Auto-detect Location', icon: const Icon(Icons.my_location_rounded), onPressed: _triggerGps),
          const SizedBox(width: 8),
        ],
      ),
      body: body,
    );
  }
}
