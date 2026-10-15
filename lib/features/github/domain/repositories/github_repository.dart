import '../entities/github_entities.dart';

abstract class GitHubRepository {
  Future<GitHubUserEntity> getUserProfile(String username);
  Future<List<GitHubRepoEntity>> getUserRepos(String username);
  Future<List<GitHubCommitEntity>> getRepoCommits(String owner, String repo);
  Future<List<GitHubIssueEntity>> getRepoIssues(String owner, String repo);
}
