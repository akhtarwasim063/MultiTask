import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DevicePlatformService {
  static const MethodChannel _channel = MethodChannel('com.nexushub.app/device');

  static Future<int> getBatteryLevel() async {
    try {
      final int level = await _channel.invokeMethod('getBatteryLevel');
      return level;
    } on PlatformException catch (e) {
      debugPrint('MethodChannel getBatteryLevel failed: ${e.message}. Using fallback.');
      return 88; // Simulated fallback for web/desktop
    } catch (_) {
      return 92;
    }
  }

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final Map<dynamic, dynamic>? info = await _channel.invokeMethod('getDeviceInfo');
      if (info != null) {
        return info.map((k, v) => MapEntry(k.toString(), v));
      }
    } on PlatformException catch (e) {
      debugPrint('MethodChannel getDeviceInfo failed: ${e.message}. Using fallback.');
    } catch (_) {}

    // Cross-platform fallback telemetry
    return {
      'model': kIsWeb ? 'Web Browser Virtual Node' : 'Nexus Workstation',
      'manufacturer': kIsWeb ? 'HTML5 Web Engine' : 'Desktop OS',
      'osVersion': kIsWeb ? 'WASM / CanvasKit' : 'Cross-Platform Core',
      'platformName': kIsWeb ? 'Flutter Web' : defaultTargetPlatform.name,
      'isPhysicalDevice': !kIsWeb,
    };
  }

  static Future<void> triggerHaptic(String type) async {
    try {
      await _channel.invokeMethod('triggerHaptic', {'type': type});
    } on PlatformException catch (e) {
      debugPrint('MethodChannel triggerHaptic failed: ${e.message}');
      // Fallback to standard HapticFeedback from Flutter services
      if (type == 'light') {
        HapticFeedback.lightImpact();
      } else if (type == 'heavy') {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.mediumImpact();
      }
    } catch (_) {
      HapticFeedback.mediumImpact();
    }
  }
}
