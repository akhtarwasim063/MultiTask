class GitHubUserEntity {
  final String login;
  final String name;
  final String avatarUrl;
  final String bio;
  final String company;
  final String blog;
  final String location;
  final int publicRepos;
  final int followers;
  final int following;

  const GitHubUserEntity({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required this.company,
    required this.blog,
    required this.location,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });
}

class GitHubRepoEntity {
  final String name;
  final String fullName;
  final String description;
  final String htmlUrl;
  final int stargazersCount;
  final int forksCount;
  final String language;
  final int openIssuesCount;
  final DateTime updatedAt;

  const GitHubRepoEntity({
    required this.name,
    required this.fullName,
    required this.description,
    required this.htmlUrl,
    required this.stargazersCount,
    required this.forksCount,
    required this.language,
    required this.openIssuesCount,
    required this.updatedAt,
  });
}

class GitHubCommitEntity {
  final String sha;
  final String message;
  final String authorName;
  final DateTime date;

  const GitHubCommitEntity({
    required this.sha,
    required this.message,
    required this.authorName,
    required this.date,
  });
}

class GitHubIssueEntity {
  final int number;
  final String title;
  final String state; // 'open' or 'closed'
  final int comments;
  final DateTime createdAt;
  final String htmlUrl;

  const GitHubIssueEntity({
    required this.number,
    required this.title,
    required this.state,
    required this.comments,
    required this.createdAt,
    required this.htmlUrl,
  });
}
