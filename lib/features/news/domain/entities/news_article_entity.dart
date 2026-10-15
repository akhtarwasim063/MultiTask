class NewsArticleEntity {
  final String title;
  final String description;
  final String content;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;
  final String sourceName;
  final String author;
  final String category;

  const NewsArticleEntity({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.sourceName,
    required this.author,
    this.category = 'General',
  });
}
