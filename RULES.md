# NexusHub Engineering & Architecture Rules

This document establishes the architectural standards, code quality rules, and design patterns required for the NexusHub multi-API dashboard application.

---

## 1. Clean Architecture Standards
The codebase strictly adheres to Uncle Bob's Clean Architecture with three distinct layers:

### Data Layer (`features/<feature>/data/`)
- **Data Sources**: Handles direct API interaction using `ApiClient` (Dio). Responsible for raw JSON serialization and HTTP error mapping.
- **DTOs / Models**: Implements `fromJson` and `toJson`. Handles null-safety, default fallbacks, and schema evolution.
- **Repository Implementations**: Implements domain repository interfaces. Orchestrates remote calls with local cache fallback (`SharedPreferences` / offline fallback).

### Domain Layer (`features/<feature>/domain/`)
- **Entities**: Pure Dart objects free of framework dependencies (`Flutter`, `Dio`, etc.). Represents core business objects.
- **Repository Interfaces**: Abstract contracts defining operations without knowing the storage/network mechanism.
- **Use Cases**: Single-responsibility callable classes (e.g., `GetWeatherUseCase`, `GetApodUseCase`).

### Presentation Layer (`features/<feature>/presentation/`)
- **State Management**: StateNotifier / Riverpod providers maintaining explicit lifecycle states (`Initial`, `Loading`, `Success`, `Empty`, `Error`).
- **Widgets**: Atomic, reusable components designed for responsiveness (mobile bottom navigation, tablet/desktop sidebar).
- **Error Boundaries & Shimmers**: Every asynchronous operation renders skeleton shimmer loaders and responsive error cards with retry buttons.

---

## 2. Network Client & Resilience Rules
- **Global Interceptors**: Request logging, automatic API key injection from encrypted secure preferences, and rate-limit detection.
- **HTTP 429 & Rate-Limit Handling**: When an API returns HTTP 429 or hits quota exhaustion, the client must trigger a backoff countdown timer, display a non-intrusive banner or toast alert, and switch seamlessly to offline cached data or high-fidelity simulated feeds.
- **Retry Policy**: 3 automatic retries with exponential backoff for network timeouts (5xx status codes, socket exceptions).

---

## 3. Dynamic Theming & Multi-Palette Rules
- **6 Curated Palettes**:
  1. *Cosmic Indigo* (`#6366F1`)
  2. *Cyber Emerald* (`#10B981`)
  3. *Solar Amber* (`#F59E0B`)
  4. *Neon Crimson* (`#F43F5E`)
  5. *Royal Violet* (`#8B5CF6`)
  6. *Matt Black* (`#0D0D0D` deep matte black background, `#181818` elevated matte surfaces, `#F1F5F9` silver-white high-contrast accents)
- **Matt Black Theme Option**: Selecting the Matt Black palette forces an authentic deep matte black canvas (`#0D0D0D`) with matte elevated card surfaces, high-contrast silver borders, and glare-free aesthetics.
- **Light & Dark Mode**: Full Material 3 color scheme generation tailored to high contrast, readability, and modern glassmorphic aesthetics.
- **Theme Persistence**: Persists user selection across app restarts.

---

## 4. Internationalization & Localization (i18n) Rules
- Supported Languages: English (EN), Spanish (ES), French (FR), German (DE), Hindi (HI), Arabic (AR).
- **RTL Support**: Arabic automatically switches text direction and layout orientation to Right-to-Left (`TextDirection.rtl`).
- All user-facing strings must pass through `AppLocalizations.of(context).translate(...)`.

---

## 5. Custom Dashboard Widget Studio Rules
- Users can create, reorder, configure, and delete dynamic dashboard widgets.
- Supported Widget Types:
  - Weather Glance
  - Space APOD Banner
  - News Ticker
  - Daily Laugh Accordion
  - Custom REST API Fetcher
  - Country Quick Fact
  - Quick Notes / Dev Metric
- Custom widgets are persisted in local storage with unique IDs, user-defined refresh intervals, titles, and layout heights.

---

## 6. Native Platform Channels (MethodChannel) Rules
- Standard Channel Name: `com.nexushub.app/device`
- Methods:
  - `getBatteryLevel`: Returns battery percentage (0-100%).
  - `getDeviceInfo`: Returns hardware model, OS version, and platform specs.
  - `triggerHaptic`: Vibrates device with light, medium, or heavy haptic feedback.
- Cross-platform Fallback: On Web, Windows, or desktop targets where native Android/iOS channels may not be bound, fallback methods provide simulated telemetry to ensure zero app crashes.
