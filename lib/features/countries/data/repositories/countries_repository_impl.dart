import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/countries_repository.dart';
import '../datasources/countries_remote_datasource.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource _remoteDataSource;
  List<CountryEntity>? _cache;

  CountriesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CountryEntity>> getAllCountries() async {
    final list = await _remoteDataSource.fetchAllCountries();
    _cache = list;
    return list;
  }

  @override
  Future<List<CountryEntity>> getCountriesByRegion(String region) async {
    return _remoteDataSource.fetchCountriesByRegion(region);
  }

  @override
  Future<CountryEntity?> getCountryByCode(String code) async {
    final searchCode = code.toUpperCase().trim();
    if (_cache == null || _cache!.isEmpty) {
      await getAllCountries();
    }
    try {
      return _cache?.firstWhere(
        (c) => c.cca2 == searchCode || c.cca3 == searchCode,
      );
    } catch (_) {
      return null;
    }
  }
}
