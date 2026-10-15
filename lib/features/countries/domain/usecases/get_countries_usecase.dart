import '../entities/country_entity.dart';
import '../repositories/countries_repository.dart';

class GetCountriesUseCase {
  final CountriesRepository _repository;

  GetCountriesUseCase(this._repository);

  Future<List<CountryEntity>> getAll() {
    return _repository.getAllCountries();
  }

  Future<List<CountryEntity>> getByRegion(String region) {
    if (region.isEmpty || region.toLowerCase() == 'all') {
      return _repository.getAllCountries();
    }
    return _repository.getCountriesByRegion(region);
  }

  Future<CountryEntity?> getByCode(String code) {
    return _repository.getCountryByCode(code);
  }
}
