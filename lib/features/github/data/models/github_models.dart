import '../../domain/entities/github_entities.dart';

class GitHubUserModel extends GitHubUserEntity {
  const GitHubUserModel({
    required super.login,
    required super.name,
    required super.avatarUrl,
    required super.bio,
    required super.company,
    required super.blog,
    required super.location,
    required super.publicRepos,
    required super.followers,
    required super.following,
  });

  factory GitHubUserModel.fromJson(Map<String, dynamic> json) {
    return GitHubUserModel(
      login: json['login']?.toString() ?? 'developer',
      name: json['name']?.toString() ?? json['login']?.toString() ?? 'Dev Engineer',
      avatarUrl: json['avatar_url']?.toString() ?? 'https://avatars.githubusercontent.com/u/14101776?v=4',
      bio: json['bio']?.toString() ?? 'Open source enthusiast & developer.',
      company: json['company']?.toString() ?? 'Community',
      blog: json['blog']?.toString() ?? '',
      location: json['location']?.toString() ?? 'Global',
      publicRepos: (json['public_repos'] as num?)?.toInt() ?? 0,
      followers: (json['followers'] as num?)?.toInt() ?? 0,
      following: (json['following'] as num?)?.toInt() ?? 0,
    );
  }
}

class GitHubRepoModel extends GitHubRepoEntity {
  const GitHubRepoModel({
    required super.name,
    required super.fullName,
    required super.description,
    required super.htmlUrl,
    required super.stargazersCount,
    required super.forksCount,
    required super.language,
    required super.openIssuesCount,
    required super.updatedAt,
  });

  factory GitHubRepoModel.fromJson(Map<String, dynamic> json) {
    DateTime updated;
    if (json['updated_at'] != null) {
      updated = DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now();
    } else {
      updated = DateTime.now();
    }

    return GitHubRepoModel(
      name: json['name']?.toString() ?? 'repo',
      fullName: json['full_name']?.toString() ?? 'user/repo',
      description: json['description']?.toString() ?? 'No description provided.',
      htmlUrl: json['html_url']?.toString() ?? 'https://github.com',
      stargazersCount: (json['stargazers_count'] as num?)?.toInt() ?? 0,
      forksCount: (json['forks_count'] as num?)?.toInt() ?? 0,
      language: json['language']?.toString() ?? 'Dart',
      openIssuesCount: (json['open_issues_count'] as num?)?.toInt() ?? 0,
      updatedAt: updated,
    );
  }
}

class GitHubCommitModel extends GitHubCommitEntity {
  const GitHubCommitModel({
    required super.sha,
    required super.message,
    required super.authorName,
    required super.date,
  });

  factory GitHubCommitModel.fromJson(Map<String, dynamic> json) {
    final commit = json['commit'] as Map<String, dynamic>? ?? {};
    final author = commit['author'] as Map<String, dynamic>? ?? {};

    DateTime commitDate;
    if (author['date'] != null) {
      commitDate = DateTime.tryParse(author['date'].toString()) ?? DateTime.now();
    } else {
      commitDate = DateTime.now();
    }

    return GitHubCommitModel(
      sha: (json['sha']?.toString() ?? '0000000').substring(0, 7),
      message: commit['message']?.toString() ?? 'Updated codebase',
      authorName: author['name']?.toString() ?? 'Dev',
      date: commitDate,
    );
  }
}

class GitHubIssueModel extends GitHubIssueEntity {
  const GitHubIssueModel({
    required super.number,
    required super.title,
    required super.state,
    required super.comments,
    required super.createdAt,
    required super.htmlUrl,
  });

  factory GitHubIssueModel.fromJson(Map<String, dynamic> json) {
    DateTime created;
    if (json['created_at'] != null) {
      created = DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now();
    } else {
      created = DateTime.now();
    }

    return GitHubIssueModel(
      number: (json['number'] as num?)?.toInt() ?? 1,
      title: json['title']?.toString() ?? 'Untitled Issue',
      state: json['state']?.toString() ?? 'open',
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      createdAt: created,
      htmlUrl: json['html_url']?.toString() ?? 'https://github.com',
    );
  }
}
