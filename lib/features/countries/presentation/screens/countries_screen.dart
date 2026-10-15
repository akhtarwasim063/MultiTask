import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/state_view.dart';
import '../../domain/entities/country_entity.dart';
import '../providers/countries_provider.dart';
import 'country_detail_modal.dart';
import 'flag_quiz_modal.dart';

class CountriesScreen extends ConsumerStatefulWidget {
  final bool showAppBar;

  const CountriesScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  ConsumerState<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends ConsumerState<CountriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _regions = [
    'All',
    'Africa',
    'Americas',
    'Asia',
    'Europe',
    'Oceania',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCountryDetail(CountryEntity country) {
    CountryDetailModal.show(
      context,
      country,
      onNavigateBorder: (code) async {
        final borderCountry = await ref.read(countriesProvider.notifier).getCountryByCode(code);
        if (borderCountry != null && mounted) {
          _openCountryDetail(borderCountry);
        }
      },
    );
  }

  void _openQuiz(List<CountryEntity> countries) {
    FlagQuizModal.show(context, countries);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(countriesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final numFormat = NumberFormat('#,###');

    final body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Search Input & Quiz Action
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    ref.read(countriesProvider.notifier).setSearchQuery(val);
                  },
                  decoration: InputDecoration(
                    hintText: context.tr('search_country'),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(countriesProvider.notifier).setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              if (!widget.showAppBar) ...[
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: context.tr('flag_quiz'),
                  icon: const Icon(Icons.videogame_asset_rounded, color: Colors.amberAccent),
                  onPressed: () => _openQuiz(state.allCountries),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Region filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _regions.map((region) {
                final isSelected = state.activeRegion == region;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(region == 'All' ? context.tr('all_regions') : region),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(countriesProvider.notifier).setRegion(region);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Country Catalog List
          Expanded(
            child: StateView<List<CountryEntity>>(
              state: state.listState,
              onRetry: () => ref.read(countriesProvider.notifier).loadCountries(),
              onSuccess: (context, countries) {
                return ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width >= 850
                        ? 24.0
                        : (115.0 + MediaQuery.paddingOf(context).bottom),
                  ),
                  itemCount: countries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (ctx, index) {
                    final country = countries[index];
                    return GlassContainer(
                      padding: const EdgeInsets.all(12),
                      onTap: () => _openCountryDetail(country),
                      child: Row(
                        children: [
                          // Flag thumbnail
                          Container(
                            width: 52,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                country.flagPng,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.flag, size: 20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  country.commonName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${country.capital} • ${country.region}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Currency & Population badge
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  country.currencySymbol.isNotEmpty
                                      ? country.currencySymbol
                                      : country.cca2,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                numFormat.format(country.population),
                                style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
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

    if (!widget.showAppBar) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('world_atlas')),
        actions: [
          IconButton(
            tooltip: context.tr('flag_quiz'),
            icon: const Icon(Icons.videogame_asset_rounded, color: Colors.amberAccent),
            onPressed: () => _openQuiz(state.allCountries),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: body,
    );
  }
}
