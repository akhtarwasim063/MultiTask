import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/demo_data.dart';
import '../../../../core/network/api_client.dart';
import '../models/country_model.dart';

abstract class CountriesRemoteDataSource {
  Future<List<CountryModel>> fetchAllCountries();
  Future<List<CountryModel>> fetchCountriesByRegion(String region);
}

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final ApiClient _client;

  CountriesRemoteDataSourceImpl(this._client);

  @override
  Future<List<CountryModel>> fetchAllCountries() async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.restCountriesBase}/all',
        queryParameters: {
          'fields': 'name,cca2,cca3,capital,region,subregion,population,currencies,languages,borders,flags'
        },
        cacheKey: 'countries_all',
        fallbackData: DemoData.countriesSample,
      );

      if (response is List) {
        return response
            .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    return DemoData.countriesSample
        .map((item) => CountryModel.fromJson(item))
        .toList();
  }

  @override
  Future<List<CountryModel>> fetchCountriesByRegion(String region) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.restCountriesBase}/region/${region.toLowerCase()}',
        cacheKey: 'countries_region_$region',
        fallbackData: DemoData.countriesSample,
      );

      if (response is List) {
        return response
            .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    final all = await fetchAllCountries();
    return all.where((c) => c.region.toLowerCase() == region.toLowerCase()).toList();
  }
}
