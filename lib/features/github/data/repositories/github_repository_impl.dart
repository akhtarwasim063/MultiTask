import '../../domain/entities/github_entities.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasources/github_remote_datasource.dart';

class GitHubRepositoryImpl implements GitHubRepository {
  final GitHubRemoteDataSource _remoteDataSource;

  GitHubRepositoryImpl(this._remoteDataSource);

  @override
  Future<GitHubUserEntity> getUserProfile(String username) {
    return _remoteDataSource.fetchUserProfile(username);
  }

  @override
  Future<List<GitHubRepoEntity>> getUserRepos(String username) {
    return _remoteDataSource.fetchUserRepos(username);
  }

  @override
  Future<List<GitHubCommitEntity>> getRepoCommits(String owner, String repo) {
    return _remoteDataSource.fetchRepoCommits(owner, repo);
  }

  @override
  Future<List<GitHubIssueEntity>> getRepoIssues(String owner, String repo) {
    return _remoteDataSource.fetchRepoIssues(owner, repo);
  }
}
