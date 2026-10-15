# Platform Channels Rules

### Architecture
- MethodChannel ID: `com.nexushub.app/device`
- Bridges native platform capabilities to Flutter presentation logic.

### Supported Methods
1. `getBatteryLevel`:
   - Returns integer percentage (0-100).
   - On Android: Uses `BatteryManager`.
   - On fallback / unsupported platforms: Queries system or returns simulated battery telemetry.
2. `getDeviceInfo`:
   - Returns a Map with `osVersion`, `model`, `platformName`, `isPhysicalDevice`.
   - Useful for system diagnostics inside Settings screen.
3. `triggerHaptic`:
   - Triggers native vibration effect (`light`, `medium`, `heavy`).

### Fallback Guarantee
- Every MethodChannel invocation must be wrapped in a `try-catch(PlatformException)` block, ensuring zero unhandled crashes on web, desktop, or mock environments.
