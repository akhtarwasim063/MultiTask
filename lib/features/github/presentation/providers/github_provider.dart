import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/state_view.dart';
import '../../data/datasources/github_remote_datasource.dart';
import '../../data/repositories/github_repository_impl.dart';
import '../../domain/entities/github_entities.dart';
import '../../domain/repositories/github_repository.dart';
import '../../domain/usecases/get_github_data_usecase.dart';

final gitHubRemoteDataSourceProvider = Provider<GitHubRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return GitHubRemoteDataSourceImpl(client);
});

final gitHubRepositoryProvider = Provider<GitHubRepository>((ref) {
  final ds = ref.watch(gitHubRemoteDataSourceProvider);
  return GitHubRepositoryImpl(ds);
});

final getGitHubDataUseCaseProvider = Provider<GetGitHubDataUseCase>((ref) {
  final repo = ref.watch(gitHubRepositoryProvider);
  return GetGitHubDataUseCase(repo);
});

class GitHubStudioState {
  final UiState<GitHubUserEntity> userState;
  final UiState<List<GitHubRepoEntity>> reposState;
  final UiState<List<GitHubCommitEntity>> commitsState;
  final UiState<List<GitHubIssueEntity>> issuesState;
  final String activeUsername;
  final String? activeRepo;

  const GitHubStudioState({
    required this.userState,
    required this.reposState,
    required this.commitsState,
    required this.issuesState,
    this.activeUsername = 'flutter',
    this.activeRepo,
  });

  GitHubStudioState copyWith({
    UiState<GitHubUserEntity>? userState,
    UiState<List<GitHubRepoEntity>>? reposState,
    UiState<List<GitHubCommitEntity>>? commitsState,
    UiState<List<GitHubIssueEntity>>? issuesState,
    String? activeUsername,
    String? activeRepo,
  }) {
    return GitHubStudioState(
      userState: userState ?? this.userState,
      reposState: reposState ?? this.reposState,
      commitsState: commitsState ?? this.commitsState,
      issuesState: issuesState ?? this.issuesState,
      activeUsername: activeUsername ?? this.activeUsername,
      activeRepo: activeRepo ?? this.activeRepo,
    );
  }
}

class GitHubNotifier extends StateNotifier<GitHubStudioState> {
  final GetGitHubDataUseCase _useCase;

  GitHubNotifier(this._useCase)
      : super(const GitHubStudioState(
          userState: InitialState(),
          reposState: InitialState(),
          commitsState: InitialState(),
          issuesState: InitialState(),
        )) {
    loadUser('flutter');
  }

  Future<void> loadUser(String username) async {
    final clean = username.trim().isEmpty ? 'flutter' : username.trim();
    state = state.copyWith(
      activeUsername: clean,
      userState: const LoadingState(),
      reposState: const LoadingState(),
    );

    try {
      final user = await _useCase.getUser(clean);
      final repos = await _useCase.getRepos(clean);

      state = state.copyWith(
        userState: SuccessState(user),
        reposState: repos.isEmpty
            ? const EmptyState('No public repositories found for this user.')
            : SuccessState(repos),
        activeRepo: repos.isNotEmpty ? repos[0].name : null,
      );

      if (repos.isNotEmpty) {
        loadRepoDetails(clean, repos[0].name);
      }
    } catch (e) {
      state = state.copyWith(
        userState: ErrorState(e.toString()),
        reposState: ErrorState(e.toString()),
      );
    }
  }

  Future<void> loadRepoDetails(String owner, String repo) async {
    state = state.copyWith(
      activeRepo: repo,
      commitsState: const LoadingState(),
      issuesState: const LoadingState(),
    );

    try {
      final commits = await _useCase.getCommits(owner, repo);
      final issues = await _useCase.getIssues(owner, repo);

      state = state.copyWith(
        commitsState: commits.isEmpty ? const EmptyState('No recent commits.') : SuccessState(commits),
        issuesState: issues.isEmpty ? const EmptyState('No issues found.') : SuccessState(issues),
      );
    } catch (e) {
      state = state.copyWith(
        commitsState: ErrorState(e.toString()),
        issuesState: ErrorState(e.toString()),
      );
    }
  }
}

final gitHubProvider =
    StateNotifierProvider<GitHubNotifier, GitHubStudioState>((ref) {
  final useCase = ref.watch(getGitHubDataUseCaseProvider);
  return GitHubNotifier(useCase);
});
