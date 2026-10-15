import '../../domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.commonName,
    required super.officialName,
    required super.cca2,
    required super.cca3,
    required super.capital,
    required super.region,
    required super.subregion,
    required super.population,
    required super.currencyCode,
    required super.currencyName,
    required super.currencySymbol,
    required super.languages,
    required super.borders,
    required super.flagPng,
    required super.flagSvg,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final nameMap = json['name'] as Map<String, dynamic>? ?? {};
    final flagsMap = json['flags'] as Map<String, dynamic>? ?? {};
    final capitalsList = json['capital'] as List<dynamic>? ?? [];
    final bordersList = json['borders'] as List<dynamic>? ?? [];
    final currenciesMap = json['currencies'] as Map<String, dynamic>? ?? {};
    final languagesMap = json['languages'] as Map<String, dynamic>? ?? {};

    String currCode = '';
    String currName = '';
    String currSymbol = '';
    if (currenciesMap.isNotEmpty) {
      currCode = currenciesMap.keys.first;
      final currInfo = currenciesMap[currCode];
      if (currInfo is Map<String, dynamic>) {
        currName = currInfo['name']?.toString() ?? '';
        currSymbol = currInfo['symbol']?.toString() ?? '';
      }
    }

    final langs = languagesMap.values.map((v) => v.toString()).toList();

    return CountryModel(
      commonName: nameMap['common']?.toString() ?? 'Unknown Country',
      officialName: nameMap['official']?.toString() ?? '',
      cca2: json['cca2']?.toString() ?? '',
      cca3: json['cca3']?.toString() ?? '',
      capital: capitalsList.isNotEmpty ? capitalsList[0].toString() : 'N/A',
      region: json['region']?.toString() ?? 'Global',
      subregion: json['subregion']?.toString() ?? '',
      population: (json['population'] as num?)?.toInt() ?? 0,
      currencyCode: currCode,
      currencyName: currName,
      currencySymbol: currSymbol,
      languages: langs,
      borders: bordersList.map((e) => e.toString()).toList(),
      flagPng: flagsMap['png']?.toString() ?? 'https://flagcdn.com/w320/un.png',
      flagSvg: flagsMap['svg']?.toString() ?? '',
    );
  }
}
