// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/services.dart';
// import 'dart:typed_data';
// import 'dart:io';
// import 'dart:isolate';
// import 'package:image/image.dart' as img;

// class ModelRecognitionService {
//   static Interpreter? _interpreter;
//   static CameraController? _cameraController;
//   static bool _isInitialized = false;
//   static bool _initialized = false;

//   static Future<void> initialize() async {
//     if (_isInitialized) return;

//     try {
//       // Initialize TFLite
//       final options = InterpreterOptions()
//         ..threads = 4
//         ..useNnApiForAndroid = true;
      
//       _interpreter = await Interpreter.fromAsset(
//         'assets/model/object_detection.tflite',
//         options: options,
//       );

//       // Initialize camera
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) {
//         throw CameraException('No cameras available', 'No cameras were found on the device');
//       }

//       _cameraController = CameraController(
//         cameras.first,
//         ResolutionPreset.medium,
//         enableAudio: false,
//         imageFormatGroup: Platform.isAndroid 
//             ? ImageFormatGroup.yuv420 
//             : ImageFormatGroup.bgra8888,
//       );

//       await _cameraController?.initialize();
//       _isInitialized = true;
//     } catch (e) {
//       print('Model recognition initialization error: $e');
//       _isInitialized = false;
//     }
//     _initialized = true;
//   }

//   static Future<List<Map<String, dynamic>>> detectObjects(CameraImage image) async {
//     if (_interpreter == null || !_isInitialized) return [];

//     try {
//       // Handle both BGRA8888 and YUV420 formats
//       final inputTensor = await _preprocessImage(image);
//       if (inputTensor.isEmpty) return [];
      
//       // Prepare output tensor
//       final outputsShape = [1, 10, 4]; // [batch, detections, values(x,y,w,h)]
//       final outputs = List.filled(
//         outputsShape[0] * outputsShape[1] * outputsShape[2], 
//         0.0,
//       ).reshape(outputsShape);

//       // Run inference
//       _interpreter!.run(inputTensor, outputs);
      
//       // Process results
//       return _processDetectionResults(outputs);
//     } catch (e) {
//       print('Object detection error: $e');
//       return [];
//     }
//   }

//   static Future<List<double>> _preprocessImage(CameraImage image) async {
//     try {
//       final img.Image? convertedImage = await _convertCameraImage(image);
//       if (convertedImage == null) return [];

//       // Resize and normalize image
//       final resized = img.copyResize(
//         convertedImage,
//         width: 300,
//         height: 300,
//       );

//       // Convert to float array and normalize
//       final inputArray = Float32List(1 * 300 * 300 * 3);
//       var index = 0;
      
//       for (var y = 0; y < resized.height; y++) {
//         for (var x = 0; x < resized.width; x++) {
//           final pixel = resized.getPixel(x, y);
//           inputArray[index++] = (pixel.r) / 255.0;
//           inputArray[index++] = (pixel.g) / 255.0;
//           inputArray[index++] = (pixel.b) / 255.0;
//         }
//       }

//       return inputArray.toList();
//     } catch (e) {
//       print('Error preprocessing image: $e');
//       return [];
//     }
//   }

//   static Future<img.Image?> _convertCameraImage(CameraImage image) async {
//   try {
//     // Handle iOS BGRA format
//     return _convertBGRA8888(image);
//   } catch (e) {
//     print('Error converting image: $e');
//     return null;
//   }
// }

// static img.Image _convertBGRA8888(CameraImage image) {
//   return img.Image.fromBytes(
//     width: image.width,
//     height: image.height,
//     bytes: image.planes[0].bytes.buffer,
//     order: img.ChannelOrder.bgra,
//   );
// }

//   static img.Image _convertYUV420(CameraImage image) {
//     final int width = image.width;
//     final int height = image.height;
//     final int uvRowStride = image.planes[1].bytesPerRow;
//     final int uvPixelStride = image.planes[1].bytesPerPixel!;

//     // Create Image buffer
//     final img.Image rgbImage = img.Image(width: width, height: height);

//     // Fill image buffer with plane data
//     for (int x = 0; x < width; x++) {
//       for (int y = 0; y < height; y++) {
//         final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
//         final int index = y * width + x;

//         final yp = image.planes[0].bytes[index];
//         final up = image.planes[1].bytes[uvIndex];
//         final vp = image.planes[2].bytes[uvIndex];

//         // Convert YUV to RGB
//         int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
//         int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
//         int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

//         rgbImage.setPixelRgb(x, y, r, g, b);
//       }
//     }

//     return rgbImage;
//   }

//   static List<Map<String, dynamic>> _processDetectionResults(List<dynamic> outputs) {
//     final List<Map<String, dynamic>> results = [];
    
//     for (var detection in outputs[0]) {
//       if (detection[4] > 0.5) { // Confidence threshold
//         results.add({
//           'bbox': detection.sublist(0, 4),
//           'confidence': detection[4],
//         });
//       }
//     }
    
//     return results;
//   }

//   static void dispose() {
//     _interpreter?.close();
//     _cameraController?.dispose();
//     _isInitialized = false;
//   }
// }
