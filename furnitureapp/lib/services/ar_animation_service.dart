// import 'package:lottie/lottie.dart';
// import 'package:flutter/material.dart';

// class ARAnimationService {
//   static final Map<String, LottieComposition> _cachedAnimations = {};

//   static Future<void> preloadAnimations(List<String> animationPaths) async {
//     try {
//       for (final path in animationPaths) {
//         final composition = await AssetLottie(path).load();
//         _cachedAnimations[path] = composition;
//       }
//     } catch (e) {
//       print('Animation preload error: $e');
//     }
//   }

//   static Widget buildInteractionGuide() {
//     return Lottie.asset(
//       'assets/animations/ar_guide.json',
//       width: 150,
//       height: 150,
//       repeat: true,
//       fit: BoxFit.contain,
//     );
//   }
// }
