# Clean Architecture Rules

### Layer Isolation
1. **Domain Layer**:
   - MUST NOT depend on Flutter UI, Dio, or platform plugins.
   - Entities represent immutable data structures.
   - Repository interfaces declare contracts with either `Future<T>` or `Stream<T>`.
   - Use Cases encapsulate a single business transaction.

2. **Data Layer**:
   - Implements Domain Repository interfaces.
   - Converts raw JSON maps to DTO models using explicit null-safe parsing.
   - Handles cache lookups before or alongside network requests.
   - Translates low-level network exceptions (e.g. DioException, SocketException) into domain exceptions (`ApiException`, `RateLimitException`, `OfflineException`).

3. **Presentation Layer**:
   - State management handles explicit states: `InitialState`, `LoadingState`, `SuccessState<T>`, `EmptyState`, `ErrorState`.
   - UI widgets must be decoupled from data sources; they observe state providers via Riverpod.
   - Must implement skeleton shimmer placeholders for all loading states.
