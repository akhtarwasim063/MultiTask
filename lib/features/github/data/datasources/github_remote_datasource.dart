import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/demo_data.dart';
import '../../../../core/network/api_client.dart';
import '../models/github_models.dart';

abstract class GitHubRemoteDataSource {
  Future<GitHubUserModel> fetchUserProfile(String username);
  Future<List<GitHubRepoModel>> fetchUserRepos(String username);
  Future<List<GitHubCommitModel>> fetchRepoCommits(String owner, String repo);
  Future<List<GitHubIssueModel>> fetchRepoIssues(String owner, String repo);
}

class GitHubRemoteDataSourceImpl implements GitHubRemoteDataSource {
  final ApiClient _client;

  GitHubRemoteDataSourceImpl(this._client);

  @override
  Future<GitHubUserModel> fetchUserProfile(String username) async {
    final query = username.trim().isEmpty ? 'flutter' : username.trim();

    try {
      final response = await _client.get(
        '${ApiEndpoints.githubBase}/users/$query',
        cacheKey: 'github_user_$query',
        fallbackData: DemoData.githubUserSample,
      );

      if (response is Map<String, dynamic>) {
        return GitHubUserModel.fromJson(response);
      }
    } catch (_) {}

    return GitHubUserModel.fromJson(DemoData.githubUserSample);
  }

  @override
  Future<List<GitHubRepoModel>> fetchUserRepos(String username) async {
    final query = username.trim().isEmpty ? 'flutter' : username.trim();

    try {
      final response = await _client.get(
        '${ApiEndpoints.githubBase}/users/$query/repos',
        queryParameters: {'sort': 'updated', 'per_page': 10},
        cacheKey: 'github_repos_$query',
        fallbackData: DemoData.githubReposSample,
      );

      if (response is List) {
        return response
            .map((item) => GitHubRepoModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    return DemoData.githubReposSample
        .map((item) => GitHubRepoModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<GitHubCommitModel>> fetchRepoCommits(String owner, String repo) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.githubBase}/repos/$owner/$repo/commits',
        queryParameters: {'per_page': 5},
        cacheKey: 'github_commits_${owner}_$repo',
        fallbackData: DemoData.githubCommitsSample,
      );

      if (response is List) {
        return response
            .map((item) => GitHubCommitModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    return DemoData.githubCommitsSample
        .map((item) => GitHubCommitModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<GitHubIssueModel>> fetchRepoIssues(String owner, String repo) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.githubBase}/repos/$owner/$repo/issues',
        queryParameters: {'state': 'all', 'per_page': 10},
        cacheKey: 'github_issues_${owner}_$repo',
        fallbackData: DemoData.githubIssuesSample,
      );

      if (response is List) {
        return response
            .map((item) => GitHubIssueModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    return DemoData.githubIssuesSample
        .map((item) => GitHubIssueModel.fromJson(item))
        .toList();
  }
}
