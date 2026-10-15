import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/state_view.dart';
import '../../data/datasources/countries_remote_datasource.dart';
import '../../data/repositories/countries_repository_impl.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/countries_repository.dart';
import '../../domain/usecases/get_countries_usecase.dart';

final countriesRemoteDataSourceProvider = Provider<CountriesRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return CountriesRemoteDataSourceImpl(client);
});

final countriesRepositoryProvider = Provider<CountriesRepository>((ref) {
  final ds = ref.watch(countriesRemoteDataSourceProvider);
  return CountriesRepositoryImpl(ds);
});

final getCountriesUseCaseProvider = Provider<GetCountriesUseCase>((ref) {
  final repo = ref.watch(countriesRepositoryProvider);
  return GetCountriesUseCase(repo);
});

class CountriesState {
  final UiState<List<CountryEntity>> listState;
  final String activeRegion;
  final String searchQuery;
  final List<CountryEntity> allCountries;

  const CountriesState({
    required this.listState,
    this.activeRegion = 'All',
    this.searchQuery = '',
    this.allCountries = const [],
  });

  CountriesState copyWith({
    UiState<List<CountryEntity>>? listState,
    String? activeRegion,
    String? searchQuery,
    List<CountryEntity>? allCountries,
  }) {
    return CountriesState(
      listState: listState ?? this.listState,
      activeRegion: activeRegion ?? this.activeRegion,
      searchQuery: searchQuery ?? this.searchQuery,
      allCountries: allCountries ?? this.allCountries,
    );
  }
}

class CountriesNotifier extends StateNotifier<CountriesState> {
  final GetCountriesUseCase _getCountriesUseCase;

  CountriesNotifier(this._getCountriesUseCase)
      : super(const CountriesState(listState: InitialState())) {
    loadCountries();
  }

  Future<void> loadCountries() async {
    state = state.copyWith(listState: const LoadingState());

    try {
      final list = await _getCountriesUseCase.getAll();
      state = state.copyWith(
        listState: SuccessState(list),
        allCountries: list,
      );
      _applyFilter();
    } catch (e) {
      state = state.copyWith(listState: ErrorState(e.toString()));
    }
  }

  void setRegion(String region) {
    state = state.copyWith(activeRegion: region);
    _applyFilter();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilter();
  }

  void _applyFilter() {
    var filtered = List<CountryEntity>.from(state.allCountries);

    if (state.activeRegion != 'All' && state.activeRegion.isNotEmpty) {
      filtered = filtered
          .where((c) => c.region.toLowerCase() == state.activeRegion.toLowerCase())
          .toList();
    }

    if (state.searchQuery.trim().isNotEmpty) {
      final q = state.searchQuery.toLowerCase().trim();
      filtered = filtered
          .where((c) =>
              c.commonName.toLowerCase().contains(q) ||
              c.officialName.toLowerCase().contains(q) ||
              c.cca2.toLowerCase().contains(q) ||
              c.cca3.toLowerCase().contains(q) ||
              c.capital.toLowerCase().contains(q))
          .toList();
    }

    if (filtered.isEmpty) {
      state = state.copyWith(listState: const EmptyState('No countries match your search.'));
    } else {
      state = state.copyWith(listState: SuccessState(filtered));
    }
  }

  Future<CountryEntity?> getCountryByCode(String code) {
    return _getCountriesUseCase.getByCode(code);
  }
}

final countriesProvider =
    StateNotifierProvider<CountriesNotifier, CountriesState>((ref) {
  final useCase = ref.watch(getCountriesUseCaseProvider);
  return CountriesNotifier(useCase);
});
