import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/state_view.dart';
import '../../domain/entities/nasa_entities.dart';
import '../providers/nasa_provider.dart';

class NasaScreen extends ConsumerStatefulWidget {
  final bool showAppBar;

  const NasaScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  ConsumerState<NasaScreen> createState() => _NasaScreenState();
}

class _NasaScreenState extends ConsumerState<NasaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectApodDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      ref.read(apodProvider.notifier).fetchApod(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final tabBarWidget = TabBar(
      controller: _tabController,
      indicatorColor: colorScheme.primary,
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      tabs: [
        Tab(text: context.tr('tab_apod'), icon: const Icon(Icons.auto_awesome_rounded, size: 18)),
        Tab(text: context.tr('tab_mars'), icon: const Icon(Icons.camera_alt_rounded, size: 18)),
        Tab(text: context.tr('tab_neo'), icon: const Icon(Icons.track_changes_rounded, size: 18)),
      ],
    );

    final tabViews = TabBarView(
      controller: _tabController,
      children: [
        _ApodTab(onSelectDate: () => _selectApodDate(context)),
        const _MarsRoverTab(),
        const _NeoAsteroidsTab(),
      ],
    );

    if (!widget.showAppBar) {
      return Column(
        children: [
          const SizedBox(height: 8),
          tabBarWidget,
          Expanded(child: tabViews),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('deep_space')),
        bottom: tabBarWidget,
      ),
      body: tabViews,
    );
  }
}

// -------------------------------------------------------------
// TAB 1: APOD (Astronomy Picture of the Day)
// -------------------------------------------------------------
class _ApodTab extends ConsumerWidget {
  final VoidCallback onSelectDate;

  const _ApodTab({required this.onSelectDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apodState = ref.watch(apodProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomPad = MediaQuery.of(context).size.width >= 850
        ? 24.0
        : (115.0 + MediaQuery.paddingOf(context).bottom);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(18, 18, 18, bottomPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.tr('nasa_apod_banner'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onSelectDate,
                icon: const Icon(Icons.calendar_month_rounded, size: 16),
                label: const Text('Pick Date'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          StateView<NasaApodEntity>(
            state: apodState,
            loadingHeight: 340,
            onRetry: () => ref.read(apodProvider.notifier).fetchApod(),
            onSuccess: (context, apod) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // High-Res Astronomical Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.network(
                        apod.url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.black45,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 48, color: Colors.white30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info Card
                  GlassContainer(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                apod.date,
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.hd_rounded, size: 20, color: Colors.amberAccent),
                                SizedBox(width: 4),
                                Text(
                                  'JWST / Hubble Feed',
                                  style: TextStyle(fontSize: 11, color: Colors.amberAccent),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          apod.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          apod.explanation,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: colorScheme.onSurface.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 2: Mars Rover
// -------------------------------------------------------------
class _MarsRoverTab extends ConsumerWidget {
  const _MarsRoverTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roverState = ref.watch(marsRoverProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final rovers = ['Curiosity', 'Opportunity', 'Spirit'];
    final cameras = ['ALL', 'FHAZ', 'RHAZ', 'NAVCAM', 'MAST'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          const SizedBox(height: 14),
          // Rover selection chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: rovers.map((rover) {
                final isSelected = roverState.activeRover.toLowerCase() == rover.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(rover),
                    selected: isSelected,
                    onSelected: (_) => ref.read(marsRoverProvider.notifier).setRover(rover),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Camera selection chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: cameras.map((cam) {
                final isSelected = cam == 'ALL'
                    ? (roverState.activeCamera == null || roverState.activeCamera!.isEmpty)
                    : roverState.activeCamera?.toUpperCase() == cam;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cam),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(marsRoverProvider.notifier).setCamera(cam == 'ALL' ? null : cam);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Photos Grid
          Expanded(
            child: StateView<List<MarsPhotoEntity>>(
              state: roverState.photosState,
              onRetry: () => ref.read(marsRoverProvider.notifier).fetchPhotos(),
              onSuccess: (context, photos) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 600;
                    return GridView.builder(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.width >= 850
                            ? 24.0
                            : (115.0 + MediaQuery.paddingOf(context).bottom),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 3 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: photos.length,
                      itemBuilder: (ctx, i) {
                        final photo = photos[i];
                        return GlassContainer(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Image.network(
                                    photo.imgSrc,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: Colors.grey[900],
                                      child: const Icon(Icons.broken_image, color: Colors.white24),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(9),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${photo.cameraName} • Sol ${photo.sol}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      photo.earthDate,
                                      style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 3: Asteroids (Near-Earth Objects)
// -------------------------------------------------------------
class _NeoAsteroidsTab extends ConsumerWidget {
  const _NeoAsteroidsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final neoState = ref.watch(neoProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Today\'s Close Approaches',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.read(neoProvider.notifier).fetchNeo(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StateView<List<NeoAsteroidEntity>>(
              state: neoState,
              onRetry: () => ref.read(neoProvider.notifier).fetchNeo(),
              onSuccess: (context, asteroids) {
                return ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width >= 850
                        ? 24.0
                        : (115.0 + MediaQuery.paddingOf(context).bottom),
                  ),
                  itemCount: asteroids.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) {
                    final neo = asteroids[i];
                    final isHazard = neo.isPotentiallyHazardous;

                    return GlassContainer(
                      padding: const EdgeInsets.all(16),
                      border: Border.all(
                        color: isHazard
                            ? Colors.red.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.08),
                        width: isHazard ? 1.5 : 1,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  neo.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isHazard
                                      ? Colors.red.withValues(alpha: 0.2)
                                      : Colors.green.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isHazard
                                      ? context.tr('hazardous')
                                      : context.tr('safe_orbit'),
                                  style: TextStyle(
                                    color: isHazard ? Colors.redAccent : Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _MetricCol(
                                  label: context.tr('velocity'),
                                  value: '${neo.relativeVelocityKmh} km/h',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _MetricCol(
                                  label: context.tr('miss_distance'),
                                  value: '${neo.missDistanceKm} km',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _MetricCol(
                                  label: context.tr('est_diameter'),
                                  value: '${(neo.estimatedDiameterMinKm * 1000).round()} - ${(neo.estimatedDiameterMaxKm * 1000).round()} m',
                                ),
                              ),
                            ],
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
  }
}

class _MetricCol extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
