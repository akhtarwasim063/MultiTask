import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/demo_data.dart';
import '../../../../core/network/api_client.dart';
import '../models/news_article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsArticleModel>> fetchHeadlines(String category);
  Future<List<NewsArticleModel>> searchNews(String query);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient _client;

  NewsRemoteDataSourceImpl(this._client);

  @override
  Future<List<NewsArticleModel>> fetchHeadlines(String category) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.newsApiBase}/top-headlines',
        queryParameters: {
          'category': category.toLowerCase(),
          'country': 'us',
          'pageSize': 15,
        },
        cacheKey: 'news_cat_$category',
        fallbackData: {'articles': DemoData.newsSample},
      );

      if (response is Map && response['articles'] is List) {
        return (response['articles'] as List)
            .map((item) => NewsArticleModel.fromJson(item as Map<String, dynamic>, category))
            .toList();
      }
    } catch (_) {}

    return DemoData.newsSample
        .map((item) => NewsArticleModel.fromJson(item, category))
        .toList();
  }

  @override
  Future<List<NewsArticleModel>> searchNews(String query) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.newsApiBase}/everything',
        queryParameters: {
          'q': query,
          'sortBy': 'relevancy',
          'pageSize': 15,
        },
        cacheKey: 'news_q_$query',
        fallbackData: {'articles': DemoData.newsSample},
      );

      if (response is Map && response['articles'] is List) {
        return (response['articles'] as List)
            .map((item) => NewsArticleModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    final q = query.toLowerCase();
    return DemoData.newsSample
        .where((item) =>
            item['title'].toString().toLowerCase().contains(q) ||
            item['description'].toString().toLowerCase().contains(q))
        .map((item) => NewsArticleModel.fromJson(item))
        .toList();
  }
}
