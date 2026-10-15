import '../entities/news_article_entity.dart';
import '../repositories/news_repository.dart';

class GetNewsUseCase {
  final NewsRepository _repository;

  GetNewsUseCase(this._repository);

  Future<List<NewsArticleEntity>> getHeadlines(String category) {
    return _repository.getTopHeadlines(category: category);
  }

  Future<List<NewsArticleEntity>> search(String query) {
    return _repository.searchNews(query);
  }
}
