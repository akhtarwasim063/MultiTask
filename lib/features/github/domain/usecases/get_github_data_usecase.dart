import '../entities/github_entities.dart';
import '../repositories/github_repository.dart';

class GetGitHubDataUseCase {
  final GitHubRepository _repository;

  GetGitHubDataUseCase(this._repository);

  Future<GitHubUserEntity> getUser(String username) {
    return _repository.getUserProfile(username);
  }

  Future<List<GitHubRepoEntity>> getRepos(String username) {
    return _repository.getUserRepos(username);
  }

  Future<List<GitHubCommitEntity>> getCommits(String owner, String repo) {
    return _repository.getRepoCommits(owner, repo);
  }

  Future<List<GitHubIssueEntity>> getIssues(String owner, String repo) {
    return _repository.getRepoIssues(owner, repo);
  }
}
