# Network and Resilience Rules

### HTTP Client Architecture
- Powered by `Dio` with custom interceptors:
  1. `ApiKeyInterceptor`: Appends user-supplied or default demo API keys to request headers or query params for OpenWeatherMap, NewsAPI, NASA, and GitHub.
  2. `RateLimitInterceptor`: Detects HTTP status code 429 and `X-RateLimit-Reset` headers.
  3. `LoggingInterceptor`: Logs network requests, response times, and payloads in debug mode.

### Error Resilience & Rate Limit Mitigation
- **HTTP 429 Handling**:
  - Automatically calculates backoff countdown (e.g. 30s or 60s).
  - Emits rate-limit alert to UI with remaining countdown timer.
  - Falls back immediately to cached payload or rich offline simulated data.
- **Retry Mechanism**:
  - Automatically retries idempotent GET requests up to 3 times on connection timeout or 503/504 errors.
- **Offline Cache**:
  - Each module caches its last successful response in local storage.
  - If a device is offline, cached data is rendered with an "Offline Mode - Showing Cached Data" indicator.
