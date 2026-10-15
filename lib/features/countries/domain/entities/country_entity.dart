class CountryEntity {
  final String commonName;
  final String officialName;
  final String cca2;
  final String cca3;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final String currencyCode;
  final String currencyName;
  final String currencySymbol;
  final List<String> languages;
  final List<String> borders;
  final String flagPng;
  final String flagSvg;

  const CountryEntity({
    required this.commonName,
    required this.officialName,
    required this.cca2,
    required this.cca3,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.currencyCode,
    required this.currencyName,
    required this.currencySymbol,
    required this.languages,
    required this.borders,
    required this.flagPng,
    required this.flagSvg,
  });
}
