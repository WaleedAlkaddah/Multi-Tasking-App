import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:quick_log/quick_log.dart';
import '../waleed_widget/animated_marker.dart';

class MapController1 extends GetxController {
  List<AnimatedMarker> markers = [];
  LatLng? firstMarker;
  LatLng? secondMarker;
  LatLng? setMarker;
  String defultmap = "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png";
  String satelliteMap = "https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}";
  String terrainMap = 'https://a.tile.opentopomap.org/{z}/{x}/{y}.png';
    final log = const Logger("MapController");

  final TextEditingController latController1 = TextEditingController();
  final TextEditingController longController1 = TextEditingController();
  final TextEditingController latController2 = TextEditingController();
  final TextEditingController longController2 = TextEditingController();

  void handleTap(tapPosition, LatLng latLng1) {
    if (markers.length < 2) {
      markers.add(
        AnimatedMark.buildAnimatedMarker(latLng1, 'lib/asseets/60.json'),
      );

      if (firstMarker == null) {
        firstMarker = latLng1;
        log.info("firstMarker $firstMarker",includeStackTrace: false);
      } else {
        secondMarker = latLng1;
        log.info("secondMarker $secondMarker", includeStackTrace: false);
      }
    }
    log.info("Markers Count In Map Controller : ${markers.length}", includeStackTrace: false);
    update();
  }

  setCoordinate() {
    if (latController2.text.isNotEmpty && latController2.text.isNotEmpty) {
      secondMarker = LatLng(
        double.parse(latController2.text),
        double.parse(longController2.text),
      );
      markers.add(
        AnimatedMark.buildAnimatedMarker(
            secondMarker!, 'lib/asseets/60.json'),
      );
    } else if (latController1.text.isNotEmpty &&
        latController1.text.isNotEmpty) {
      firstMarker = LatLng(
        double.parse(latController1.text),
        double.parse(longController1.text),
      );
      markers.add(
        AnimatedMark.buildAnimatedMarker(firstMarker!, 'lib/asseets/60.json'),
      );
    } else {
      log.error("Invalid input for latitude or longitude", includeStackTrace: false);
    }
    update();
  }

  void clearMarkers() {
    markers.clear();
    firstMarker = null;
    secondMarker = null;
    log.info("Cleared", includeStackTrace: false);
    update();
  }

   updateMap(String mapStyle) {
    defultmap = mapStyle;
    update();
  }

  void calculateDistance() {
    if (firstMarker != null && secondMarker != null) {
      double distance = const Distance().as(
        LengthUnit.Kilometer,
        firstMarker!,
        secondMarker!,
      );
      log.info("firstMarker calculateDistance $firstMarker", includeStackTrace: false);
      log.info("secondMarker calculateDistance $secondMarker", includeStackTrace: false);
      Get.defaultDialog(
        title: 'Distance',
        middleText: 'Distance between markers: $distance Kilometer',
        textConfirm: 'OK',
        onConfirm: () {
          Get.back();
        },
      );
    }
  }
}
