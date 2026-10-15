import '../../domain/entities/news_article_entity.dart';

class NewsArticleModel extends NewsArticleEntity {
  const NewsArticleModel({
    required super.title,
    required super.description,
    required super.content,
    required super.url,
    required super.imageUrl,
    required super.publishedAt,
    required super.sourceName,
    required super.author,
    super.category,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json, [String defaultCategory = 'General']) {
    final sourceMap = json['source'] as Map<String, dynamic>? ?? {};

    DateTime date;
    if (json['publishedAt'] != null) {
      date = DateTime.tryParse(json['publishedAt'].toString()) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    return NewsArticleModel(
      title: json['title']?.toString() ?? 'Breaking Story',
      description: json['description']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      url: json['url']?.toString() ?? 'https://news.google.com',
      imageUrl: json['urlToImage']?.toString() ??
          'https://images.unsplash.com/photo-1504711434969-e33886168f5c?q=80&w=800&auto=format&fit=crop',
      publishedAt: date,
      sourceName: sourceMap['name']?.toString() ?? 'Global News',
      author: json['author']?.toString() ?? 'Editorial Staff',
      category: json['category']?.toString() ?? defaultCategory,
    );
  }
}
