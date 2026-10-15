import '../entities/country_entity.dart';

abstract class CountriesRepository {
  Future<List<CountryEntity>> getAllCountries();
  Future<List<CountryEntity>> getCountriesByRegion(String region);
  Future<CountryEntity?> getCountryByCode(String code);
}
