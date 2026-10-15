import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../domain/entities/country_entity.dart';

class CountryDetailModal extends StatelessWidget {
  final CountryEntity country;
  final Function(String code)? onNavigateBorder;

  const CountryDetailModal({
    super.key,
    required this.country,
    this.onNavigateBorder,
  });

  static void show(
    BuildContext context,
    CountryEntity country, {
    Function(String code)? onNavigateBorder,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CountryDetailModal(
        country: country,
        onNavigateBorder: onNavigateBorder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final numFormat = NumberFormat('#,###');

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Flag & Names
                  Center(
                    child: Container(
                      width: 140,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          country.flagPng,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.flag_rounded, size: 40, color: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    country.commonName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (country.officialName.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      country.officialName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Info Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.location_city_rounded,
                          label: context.tr('capital'),
                          value: country.capital,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.people_rounded,
                          label: context.tr('population'),
                          value: numFormat.format(country.population),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.paid_rounded,
                          label: context.tr('currencies'),
                          value: '${country.currencySymbol} ${country.currencyCode}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.map_rounded,
                          label: 'Region',
                          value: '${country.region} (${country.subregion})',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Languages
                  if (country.languages.isNotEmpty) ...[
                    Text(
                      'Languages',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: country.languages.map((lang) {
                        return Chip(
                          label: Text(lang),
                          avatar: const Icon(Icons.translate, size: 14),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Tap-to-Navigate Border Country Chips
                  Text(
                    context.tr('borders'),
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (country.borders.isEmpty)
                    GlassContainer(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        context.tr('no_borders'),
                        style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: country.borders.map((borderCode) {
                        return ActionChip(
                          avatar: const Icon(Icons.near_me_rounded, size: 14),
                          label: Text(borderCode),
                          onPressed: () {
                            Navigator.pop(context);
                            onNavigateBorder?.call(borderCode);
                          },
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
