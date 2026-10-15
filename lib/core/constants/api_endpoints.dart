/// API Endpoints and API Key configuration constants
class ApiEndpoints {
  // Base URLs
  static const String openWeatherBase = 'https://api.openweathermap.org/data/2.5';
  static const String newsApiBase = 'https://newsapi.org/v2';
  static const String nasaBase = 'https://api.nasa.gov';
  static const String githubBase = 'https://api.github.com';
  static const String restCountriesBase = 'https://restcountries.com/v3.1';
  static const String jokeApiBase = 'https://v2.jokeapi.dev/joke';

  // Fallback demo keys (Users can test out of the box or add their own keys in Settings)
  // NASA's DEMO_KEY is officially supported by NASA for testing
  static const String defaultNasaKey = 'DEMO_KEY';
  
  // Public demonstration keys or tokens. If null or expired, the app gracefully falls back to mock/cached data.
  static const String defaultWeatherKey = 'b1b15e88fa797225412429c1c50c122a1'; // sample demo key
  static const String defaultNewsApiKey = 'demo_mode';
  static const String defaultGitHubToken = '';
}
