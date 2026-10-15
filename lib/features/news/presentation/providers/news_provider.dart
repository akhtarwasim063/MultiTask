import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/state_view.dart';
import '../../data/datasources/news_remote_datasource.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/entities/news_article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_news_usecase.dart';

final newsRemoteDataSourceProvider = Provider<NewsRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return NewsRemoteDataSourceImpl(client);
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final ds = ref.watch(newsRemoteDataSourceProvider);
  return NewsRepositoryImpl(ds);
});

final getNewsUseCaseProvider = Provider<GetNewsUseCase>((ref) {
  final repo = ref.watch(newsRepositoryProvider);
  return GetNewsUseCase(repo);
});

class NewsState {
  final UiState<List<NewsArticleEntity>> articlesState;
  final String activeCategory;
  final String searchQuery;

  const NewsState({
    required this.articlesState,
    this.activeCategory = 'technology',
    this.searchQuery = '',
  });

  NewsState copyWith({
    UiState<List<NewsArticleEntity>>? articlesState,
    String? activeCategory,
    String? searchQuery,
  }) {
    return NewsState(
      articlesState: articlesState ?? this.articlesState,
      activeCategory: activeCategory ?? this.activeCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  final GetNewsUseCase _getNewsUseCase;

  NewsNotifier(this._getNewsUseCase)
      : super(const NewsState(articlesState: InitialState())) {
    fetchHeadlines('technology');
  }

  Future<void> fetchHeadlines(String category) async {
    state = state.copyWith(
      activeCategory: category,
      searchQuery: '',
      articlesState: const LoadingState(),
    );

    try {
      final list = await _getNewsUseCase.getHeadlines(category);
      if (list.isEmpty) {
        state = state.copyWith(articlesState: const EmptyState('No articles found in this category.'));
      } else {
        state = state.copyWith(articlesState: SuccessState(list));
      }
    } catch (e) {
      state = state.copyWith(articlesState: ErrorState(e.toString()));
    }
  }

  Future<void> search(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) {
      fetchHeadlines(state.activeCategory);
      return;
    }

    state = state.copyWith(
      searchQuery: clean,
      articlesState: const LoadingState(),
    );

    try {
      final list = await _getNewsUseCase.search(clean);
      if (list.isEmpty) {
        state = state.copyWith(articlesState: const EmptyState('No articles matched your search query.'));
      } else {
        state = state.copyWith(articlesState: SuccessState(list));
      }
    } catch (e) {
      state = state.copyWith(articlesState: ErrorState(e.toString()));
    }
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  final useCase = ref.watch(getNewsUseCaseProvider);
  return NewsNotifier(useCase);
});
