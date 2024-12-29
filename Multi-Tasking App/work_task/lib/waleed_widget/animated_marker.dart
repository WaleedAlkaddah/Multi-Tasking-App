import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' as lottie;

class AnimatedMark {

 static buildAnimatedMarker(LatLng point, String animationPath) {

    return AnimatedMarker(
      point: point,
      builder: (_, __) => lottie.Lottie.asset(
        animationPath,
        width: 800,
        height: 800,
      ),
    );
  }
}
