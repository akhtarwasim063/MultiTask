import '../entities/news_article_entity.dart';

abstract class NewsRepository {
  Future<List<NewsArticleEntity>> getTopHeadlines({String category = 'general'});
  Future<List<NewsArticleEntity>> searchNews(String query);
}
