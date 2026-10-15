import '../../domain/entities/news_article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;

  NewsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<NewsArticleEntity>> getTopHeadlines({String category = 'general'}) {
    return _remoteDataSource.fetchHeadlines(category);
  }

  @override
  Future<List<NewsArticleEntity>> searchNews(String query) {
    return _remoteDataSource.searchNews(query);
  }
}
