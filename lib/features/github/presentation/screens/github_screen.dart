import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/state_view.dart';
import '../../domain/entities/github_entities.dart';
import '../providers/github_provider.dart';

class GitHubScreen extends ConsumerStatefulWidget {
  final bool showAppBar;

  const GitHubScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  ConsumerState<GitHubScreen> createState() => _GitHubScreenState();
}

class _GitHubScreenState extends ConsumerState<GitHubScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(gitHubProvider.notifier).loadUser(query);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gitHubProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final numFormat = NumberFormat('#,###');

    final content = NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
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
                          hintText: context.tr('search_github_user'),
                          prefixIcon: const Icon(Icons.search_rounded),
                        ),
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
                  ],
                ),
                const SizedBox(height: 14),

                // Profile Card (StateView)
                StateView<GitHubUserEntity>(
                  state: state.userState,
                  loadingHeight: 180,
                  onRetry: () => ref.read(gitHubProvider.notifier).loadUser(state.activeUsername),
                  onSuccess: (context, user) {
                    return GlassContainer(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundImage: NetworkImage(user.avatarUrl),
                                backgroundColor: Colors.grey[800],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      '@${user.login}',
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (user.bio.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        user.bio,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                      ),
                                    ],
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 4,
                                      children: [
                                        if (user.location.isNotEmpty)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.location_on_outlined, size: 13, color: Colors.grey),
                                              const SizedBox(width: 2),
                                              Text(
                                                user.location,
                                                style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                                              ),
                                            ],
                                          ),
                                        if (user.company.isNotEmpty)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.business_outlined, size: 13, color: Colors.grey),
                                              const SizedBox(width: 2),
                                              Text(
                                                user.company,
                                                style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(),
                          const SizedBox(height: 8),
                          // Metric counters
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _ProfileMetric(
                                label: context.tr('public_repos'),
                                value: numFormat.format(user.publicRepos),
                                icon: Icons.source_rounded,
                              ),
                              _ProfileMetric(
                                label: context.tr('followers'),
                                value: numFormat.format(user.followers),
                                icon: Icons.people_outline_rounded,
                              ),
                              _ProfileMetric(
                                label: context.tr('following'),
                                value: numFormat.format(user.following),
                                icon: Icons.person_add_alt_1_outlined,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TabBar(
              controller: _tabController,
              indicatorColor: colorScheme.primary,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(text: context.tr('repositories')),
                Tab(text: context.tr('commit_timeline')),
                Tab(text: context.tr('issue_tracker')),
              ],
            ),
          ),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Repositories Explorer
            StateView<List<GitHubRepoEntity>>(
              state: state.reposState,
              onRetry: () => ref.read(gitHubProvider.notifier).loadUser(state.activeUsername),
              onSuccess: (context, repos) {
                return ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width >= 850
                        ? 24.0
                        : (115.0 + MediaQuery.paddingOf(context).bottom),
                  ),
                  itemCount: repos.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final repo = repos[i];
                    final isSelected = state.activeRepo == repo.name;

                    return GlassContainer(
                      padding: const EdgeInsets.all(14),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.06)),
                      ),
                      onTap: () {
                        ref
                            .read(gitHubProvider.notifier)
                            .loadRepoDetails(state.activeUsername, repo.name);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  repo.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isSelected ? colorScheme.primary : null,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.open_in_new, size: 16),
                                onPressed: () => _openUrl(repo.htmlUrl),
                              ),
                            ],
                          ),
                          if (repo.description.isNotEmpty) ...[
                            Text(
                              repo.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  repo.language.isNotEmpty ? repo.language : 'Code',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                numFormat.format(repo.stargazersCount),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 14),
                              const Icon(Icons.fork_right_rounded, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                numFormat.format(repo.forksCount),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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

            // Tab 2: Commit Timeline
            StateView<List<GitHubCommitEntity>>(
              state: state.commitsState,
              onRetry: () {
                if (state.activeRepo != null) {
                  ref
                      .read(gitHubProvider.notifier)
                      .loadRepoDetails(state.activeUsername, state.activeRepo!);
                }
              },
              onSuccess: (context, commits) {
                return ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width >= 850
                        ? 24.0
                        : (115.0 + MediaQuery.paddingOf(context).bottom),
                  ),
                  itemCount: commits.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final commit = commits[i];
                    return GlassContainer(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              commit.sha,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  commit.message,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${commit.authorName} • ${DateFormat('MMM d, y HH:mm').format(commit.date)}',
                                  style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
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
            ),

            // Tab 3: Issues Tracker
            StateView<List<GitHubIssueEntity>>(
              state: state.issuesState,
              onRetry: () {
                if (state.activeRepo != null) {
                  ref
                      .read(gitHubProvider.notifier)
                      .loadRepoDetails(state.activeUsername, state.activeRepo!);
                }
              },
              onSuccess: (context, issues) {
                return ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width >= 850
                        ? 24.0
                        : (115.0 + MediaQuery.paddingOf(context).bottom),
                  ),
                  itemCount: issues.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final issue = issues[i];
                    final isOpen = issue.state.toLowerCase() == 'open';

                    return GlassContainer(
                      padding: const EdgeInsets.all(12),
                      onTap: () => _openUrl(issue.htmlUrl),
                      child: Row(
                        children: [
                          Icon(
                            isOpen ? Icons.adjust_rounded : Icons.check_circle_outline_rounded,
                            color: isOpen ? Colors.greenAccent : Colors.purpleAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#${issue.number} ${issue.title}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${issue.comments} comments • ${DateFormat('MMM d, y').format(issue.createdAt)}',
                                  style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );

    if (!widget.showAppBar) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('dev_studio')),
      ),
      body: content,
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
