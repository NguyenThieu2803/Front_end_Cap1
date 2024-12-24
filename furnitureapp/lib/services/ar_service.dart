import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:vector_math/vector_math_64.dart';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ArService {
  static const _modelCacheFolder = 'ar_models';

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

  /// Preloads a 3D model from URL and caches it locally
  static Future<String?> preloadModel(String modelUrl) async {
    try {
      // Generate unique cache key from URL
      final bytes = utf8.encode(modelUrl);
      final digest = sha256.convert(bytes);
      final cacheKey = digest.toString();

      // Setup cache directory
      final cacheDir = await _getCacheDirectory();
      final modelCacheDir = Directory('${cacheDir.path}/$_modelCacheFolder');
      if (!await modelCacheDir.exists()) {
        await modelCacheDir.create(recursive: true);
      }

      // Check if model already exists in cache
      final cachedFile = File('${modelCacheDir.path}/$cacheKey.glb');
      if (await cachedFile.exists()) {
        print('Loading model from cache: ${cachedFile.path}');
        return cachedFile.path;
      }

      // Download model if not cached
      print('Downloading model from: $modelUrl');
      final response = await http.get(Uri.parse(modelUrl));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to download model: ${response.statusCode}');
      }

      // Save to cache
      await cachedFile.writeAsBytes(response.bodyBytes);
      print('Model cached at: ${cachedFile.path}');
      
      return cachedFile.path;

    } catch (e) {
      print('Error preloading model: $e');
      return null;
    }
  }

  /// Get application cache directory
  static Future<Directory> _getCacheDirectory() async {
    if (Platform.isAndroid) {
      return await getTemporaryDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// Cleans old cached models
  static Future<void> cleanModelCache({Duration maxAge = const Duration(days: 7)}) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final modelCacheDir = Directory('${cacheDir.path}/$_modelCacheFolder');
      
      if (!await modelCacheDir.exists()) return;

      final now = DateTime.now();
      await for (final entity in modelCacheDir.list()) {
        if (entity is File) {
          final stat = await entity.stat();
          final age = now.difference(stat.modified);
          if (age > maxAge) {
            await entity.delete();
            print('Deleted old cached model: ${entity.path}');
          }
        }
      }
    } catch (e) {
      print('Error cleaning model cache: $e');
    }
  }
}
