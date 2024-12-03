import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:vector_math/vector_math_64.dart';

class ArService {
  static Future<bool> validateModelUrl(String modelUrl) async {
    try {
      final uri = Uri.parse(modelUrl);
      if (!uri.hasAbsolutePath) return false;
      
      final extension = modelUrl.split('.').last.toLowerCase();
      return extension == 'glb' || extension == 'gltf';
    } catch (e) {
      print('Error validating model URL: $e');
      return false;
    }
  }

  static Future<bool> checkARCapabilities() async {
    try {
      // Check camera permission first
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        print('Camera permission not granted');
        return false;
      }

      // Basic platform check
      if (Platform.isAndroid) {
        // For Android, we can add additional checks if needed
        final sdkInt = await _getAndroidSDKVersion();
        return sdkInt >= 24; // Android 7.0 or higher
      } else if (Platform.isIOS) {
        // For iOS, we can add additional checks if needed
        return true; // Assuming iOS devices support AR
      }

      return false;
    } catch (e) {
      print('Error checking AR capabilities: $e');
      return false;
    }
  }

  // Helper method to get Android SDK version
  static Future<int> _getAndroidSDKVersion() async {
    try {
      // This is a placeholder. You might want to use a platform channel
      // to get the actual SDK version from the Android side
      return 24; // Default to Android 7.0
    } catch (e) {
      return 0;
    }
  }

  static Map<String, dynamic> getDefaultModelConfig() {
    return {
      'scale': Vector3(0.2, 0.2, 0.2),
      'position': Vector3(0.0, 0.0, 0.0),
      'rotation': Vector4(1.0, 0.0, 0.0, 0.0),
    };
  }
}
