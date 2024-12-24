import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class ARiOSService {
  static Future<bool> checkARKitSupport() async {
    try {
      return await ArCoreController.checkArCoreAvailability();
    } catch (e) {
      print('Error checking ARKit support: $e');
      return false;
    }
  }

  static Vector3 adjustPositionForIOS(Vector3 position) {
    return Vector3(
      position.x,
      position.y,
      position.z - 1.0,
    );
  }
} 