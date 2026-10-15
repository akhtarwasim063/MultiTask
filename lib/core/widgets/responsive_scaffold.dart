import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_localizations.dart';
import '../platform/device_channel.dart';
import '../theme/theme_provider.dart';
import 'backoff_countdown_banner.dart';
import '../../features/countries/presentation/screens/countries_screen.dart';
import '../../features/github/presentation/screens/github_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/jokes/presentation/screens/jokes_screen.dart';
import '../../features/nasa/presentation/screens/nasa_screen.dart';
import '../../features/news/presentation/screens/news_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/weather/presentation/screens/weather_screen.dart';

final selectedNavigationIndexProvider = StateProvider<int>((ref) => 0);

class ResponsiveScaffold extends ConsumerStatefulWidget {
  final List<Widget>? screens;

  const ResponsiveScaffold({super.key, this.screens});

  @override
  ConsumerState<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends ConsumerState<ResponsiveScaffold> {
  final Set<int> _activatedIndices = {0};

  // Maps the 0..7 index to the 5 bottom navigation tabs
  int _indexToBottomTab(int index) {
    switch (index) {
      case 0:
        return 0; // Home
      case 1:
      case 2:
        return 1; // Explore (Weather / Countries)
      case 3:
      case 4:
        return 2; // Feeds (News / NASA)
      case 5:
      case 6:
        return 3; // Dev Hub (GitHub / Jokes)
      case 7:
        return 4; // Settings
      default:
        return 0;
    }
  }

  // Maps bottom tab tap (0..4) to standard index
  int _bottomTabToIndex(int tab, int currentIndex) {
    switch (tab) {
      case 0:
        return 0;
      case 1:
        // Remember previous subtab if already in explore
        return currentIndex == 2 ? 2 : 1;
      case 2:
        return currentIndex == 4 ? 4 : 3;
      case 3:
        return currentIndex == 6 ? 6 : 5;
      case 4:
        return 7;
      default:
        return 0;
    }
  }

  void _onNavigate(int index) {
    DevicePlatformService.triggerHaptic('light');
    ref.read(selectedNavigationIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(selectedNavigationIndexProvider);
    _activatedIndices.add(currentIndex);

    final isDesktop = MediaQuery.of(context).size.width >= 850;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final themeState = ref.watch(themeProvider);
    final isFrosted = themeState.isFrostedGlassEnabled;

    final bottomTabIndex = _indexToBottomTab(currentIndex);

    // Sidebar items categorized
    final sidebarSections = [
      _SidebarSection(
        header: context.tr('category_overview'),
        items: [_SidebarItem(index: 0, icon: Icons.dashboard_rounded, title: context.tr('nav_home'))],
      ),
      _SidebarSection(
        header: context.tr('category_exploration'),
        items: [
          _SidebarItem(index: 1, icon: Icons.wb_sunny_rounded, title: context.tr('nav_weather')),
          _SidebarItem(index: 2, icon: Icons.public_rounded, title: context.tr('nav_countries')),
        ],
      ),
      _SidebarSection(
        header: context.tr('category_feeds'),
        items: [
          _SidebarItem(index: 3, icon: Icons.newspaper_rounded, title: context.tr('nav_news')),
          _SidebarItem(index: 4, icon: Icons.rocket_launch_rounded, title: context.tr('nav_nasa')),
        ],
      ),
      _SidebarSection(
        header: context.tr('category_developer'),
        items: [
          _SidebarItem(index: 5, icon: Icons.code_rounded, title: context.tr('nav_github')),
          _SidebarItem(index: 6, icon: Icons.mood_rounded, title: context.tr('nav_jokes')),
        ],
      ),
      _SidebarSection(
        header: context.tr('category_system'),
        items: [_SidebarItem(index: 7, icon: Icons.tune_rounded, title: context.tr('nav_settings'))],
      ),
    ];

    // Mobile Viewport Content
    Widget mobileContent;
    switch (bottomTabIndex) {
      case 0:
        mobileContent = const HomeScreen();
        break;
      case 1:
        mobileContent = _CategoryHostScreen(
          categoryTitle: context.tr('nav_explore'),
          subTabs: [
            _CategoryTabInfo(label: context.tr('nav_weather'), icon: Icons.wb_sunny_rounded),
            _CategoryTabInfo(label: context.tr('nav_countries'), icon: Icons.public_rounded),
          ],
          selectedSubIndex: currentIndex == 2 ? 1 : 0,
          onSubTabChanged: (i) => _onNavigate(i == 0 ? 1 : 2),
          children: const [WeatherScreen(showAppBar: false), CountriesScreen(showAppBar: false)],
        );
        break;
      case 2:
        mobileContent = _CategoryHostScreen(
          categoryTitle: context.tr('nav_feeds'),
          subTabs: [
            _CategoryTabInfo(label: context.tr('nav_news'), icon: Icons.newspaper_rounded),
            _CategoryTabInfo(label: context.tr('nav_nasa'), icon: Icons.rocket_launch_rounded),
          ],
          selectedSubIndex: currentIndex == 4 ? 1 : 0,
          onSubTabChanged: (i) => _onNavigate(i == 0 ? 3 : 4),
          children: const [NewsScreen(showAppBar: false), NasaScreen(showAppBar: false)],
        );
        break;
      case 3:
        mobileContent = _CategoryHostScreen(
          categoryTitle: context.tr('nav_dev_hub'),
          subTabs: [
            _CategoryTabInfo(label: context.tr('nav_github'), icon: Icons.code_rounded),
            _CategoryTabInfo(label: context.tr('nav_jokes'), icon: Icons.mood_rounded),
          ],
          selectedSubIndex: currentIndex == 6 ? 1 : 0,
          onSubTabChanged: (i) => _onNavigate(i == 0 ? 5 : 6),
          children: const [GitHubScreen(showAppBar: false), JokesScreen(showAppBar: false)],
        );
        break;
      case 4:
        mobileContent = const SettingsScreen();
        break;
      default:
        mobileContent = const HomeScreen();
    }

    // Desktop Desktop Viewport Content (IndexedStack of all 8 screens)
    final desktopScreens = [
      const HomeScreen(),
      const WeatherScreen(),
      const CountriesScreen(),
      const NewsScreen(),
      const NasaScreen(),
      const GitHubScreen(),
      const JokesScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      extendBody: true, // Allows content to flow behind floating frosted bar
      body: Column(
        children: [
          const BackoffCountdownBanner(),
          Expanded(
            child: Row(
              children: [
                if (isDesktop)
                  // Desktop Categorized Sidebar
                  Container(
                    width: 260,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(right: BorderSide(color: isDark ? colorScheme.outline : Colors.black.withValues(alpha: 0.06))),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App Brand Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 4))],
                                ),
                                child: const Center(child: Icon(Icons.hub_rounded, color: Colors.white, size: 22)),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(context.tr('app_title'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.5)),
                                  Text(
                                    'v1.0 • Clean Arch',
                                    style: TextStyle(fontSize: 11, color: colorScheme.primary, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),

                        // Navigation List Categorized
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            itemCount: sidebarSections.length,
                            itemBuilder: (ctx, sIdx) {
                              final section = sidebarSections[sIdx];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (sIdx > 0) const SizedBox(height: 14),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, bottom: 6),
                                    child: Text(
                                      section.header.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.0,
                                        color: isDark ? const Color(0xFFCBD5E1) : colorScheme.onSurface.withValues(alpha: 0.55),
                                      ),
                                    ),
                                  ),
                                  ...section.items.map((item) {
                                    final isSelected = item.index == currentIndex;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => _onNavigate(item.index),
                                          borderRadius: BorderRadius.circular(12),
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: isSelected ? colorScheme.primary.withValues(alpha: 0.14) : Colors.transparent,
                                              borderRadius: BorderRadius.circular(12),
                                              border: isSelected ? Border.all(color: colorScheme.primary.withValues(alpha: 0.3)) : null,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  item.icon,
                                                  size: 19,
                                                  color: isSelected
                                                      ? colorScheme.primary
                                                      : (isDark ? const Color(0xFFCBD5E1) : colorScheme.onSurface.withValues(alpha: 0.65)),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    item.title,
                                                    style: TextStyle(
                                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                                      fontSize: 13,
                                                      color: isSelected
                                                          ? colorScheme.primary
                                                          : (isDark ? const Color(0xFFF1F5F9) : colorScheme.onSurface.withValues(alpha: 0.85)),
                                                    ),
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: colorScheme.primary),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              );
                            },
                          ),
                        ),

                        // Telemetry Badge
                        Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.greenAccent),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  '6 APIs Synchronized',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.greenAccent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Main Viewport
                Expanded(
                  child: isDesktop
                      ? IndexedStack(
                          index: currentIndex,
                          children: List.generate(desktopScreens.length, (idx) {
                            if (_activatedIndices.contains(idx)) {
                              return desktopScreens[idx];
                            }
                            return const SizedBox.shrink();
                          }),
                        )
                      : mobileContent,
                ),
              ],
            ),
          ),
        ],
      ),

      // Minimal Floating Frosted Glass Bottom Navigation Bar (Mobile)
      bottomNavigationBar: isDesktop
          ? null
          : _FloatingFrostedBottomBar(
              currentIndex: bottomTabIndex,
              isFrosted: isFrosted,
              onTap: (tabIdx) {
                final newIndex = _bottomTabToIndex(tabIdx, currentIndex);
                _onNavigate(newIndex);
              },
              items: [
                _BottomBarDestination(icon: Icons.space_dashboard_outlined, selectedIcon: Icons.space_dashboard_rounded, label: context.tr('nav_home')),
                _BottomBarDestination(icon: Icons.explore_outlined, selectedIcon: Icons.explore_rounded, label: context.tr('nav_explore')),
                _BottomBarDestination(icon: Icons.auto_awesome_motion_outlined, selectedIcon: Icons.auto_awesome_motion_rounded, label: context.tr('nav_feeds')),
                _BottomBarDestination(icon: Icons.terminal_outlined, selectedIcon: Icons.terminal_rounded, label: context.tr('nav_dev_hub')),
                _BottomBarDestination(icon: Icons.tune_outlined, selectedIcon: Icons.tune_rounded, label: context.tr('nav_settings')),
              ],
            ),
    );
  }
}

// -------------------------------------------------------------
// Floating Frosted Glass Bottom Navigation Bar Widget
// -------------------------------------------------------------
class _FloatingFrostedBottomBar extends StatelessWidget {
  final int currentIndex;
  final bool isFrosted;
  final ValueChanged<int> onTap;
  final List<_BottomBarDestination> items;

  const _FloatingFrostedBottomBar({required this.currentIndex, required this.isFrosted, required this.onTap, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    final bgColor = isFrosted ? (isDark ? colorScheme.surface.withValues(alpha: 0.75) : Colors.white.withValues(alpha: 0.85)) : (isDark ? colorScheme.surface : Colors.white);

    final borderColor = isFrosted
        ? (isDark ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.7))
        : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08));

    Widget content = Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;

          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(color: isSelected ? colorScheme.primary.withValues(alpha: 0.16) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.selectedIcon : item.icon,
                        size: 22,
                        color: isSelected
                            ? colorScheme.primary
                            : (isDark ? const Color(0xFFCBD5E1) : colorScheme.onSurface.withValues(alpha: 0.65)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? colorScheme.primary
                              : (isDark ? const Color(0xFFCBD5E1) : colorScheme.onSurface.withValues(alpha: 0.65)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );

    if (isFrosted) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18), child: content),
      );
    }

    return SafeArea(
      child: Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 10), child: content),
    );
  }
}

// -------------------------------------------------------------
// Category Host Screen for Mobile (Explore, Feeds, Dev Hub)
// -------------------------------------------------------------
class _CategoryHostScreen extends StatelessWidget {
  final String categoryTitle;
  final List<_CategoryTabInfo> subTabs;
  final int selectedSubIndex;
  final ValueChanged<int> onSubTabChanged;
  final List<Widget> children;

  const _CategoryHostScreen({
    required this.categoryTitle,
    required this.subTabs,
    required this.selectedSubIndex,
    required this.onSubTabChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final unselectedTextColor = isDark
        ? const Color(0xFFCBD5E1)
        : colorScheme.onSurface.withValues(alpha: 0.8);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          categoryTitle,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surfaceContainer
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? colorScheme.outline
                      : colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: List.generate(subTabs.length, (idx) {
                  final isSelected = idx == selectedSubIndex;
                  final tabInfo = subTabs[idx];

                  return Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onSubTabChanged(idx);
                          DevicePlatformService.triggerHaptic('selection');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      colorScheme.primary,
                                      colorScheme.primary.withValues(alpha: 0.88),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(alpha: 0.35),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                tabInfo.icon,
                                size: 18,
                                color: isSelected ? colorScheme.onPrimary : unselectedTextColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tabInfo.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: isSelected ? colorScheme.onPrimary : unselectedTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: children[selectedSubIndex],
      ),
    );
  }
}

class _CategoryTabInfo {
  final String label;
  final IconData icon;
  const _CategoryTabInfo({required this.label, required this.icon});
}

class _BottomBarDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _BottomBarDestination({required this.icon, required this.selectedIcon, required this.label});
}

class _SidebarSection {
  final String header;
  final List<_SidebarItem> items;
  const _SidebarSection({required this.header, required this.items});
}

class _SidebarItem {
  final int index;
  final IconData icon;
  final String title;

  const _SidebarItem({required this.index, required this.icon, required this.title});
}
