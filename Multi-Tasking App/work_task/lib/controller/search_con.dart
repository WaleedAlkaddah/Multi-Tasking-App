import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:quick_log/quick_log.dart';
import 'package:work_task/controller/map_con.dart';
import '../model/serach_mod.dart';
import 'package:flutter/material.dart';
import '../waleed_widget/animated_marker.dart';

class AddressController extends GetxController {
  final TextEditingController textAddressController = TextEditingController();
  MapController1 mapController = MapController1();
  var address = "".obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  LatLng? latLng1;
  bool showCustomMarkers = false;
    final log = const Logger("AddressController");


  Future<void> getAddressInfo() async {
    var model = AddressModel(address: "", latitude: 0.0, longitude: 0.0);
    log.info(textAddressController.text,includeStackTrace: false);
    await model.getAddressInfo(textAddressController.text);
    address.value = model.address;
    latitude.value = model.latitude;
    longitude.value = model.longitude;
    latLng1 = LatLng(latitude.value, longitude.value);
    mapController.markers.add(
      AnimatedMark.buildAnimatedMarker(latLng1!, 'lib/asseets/60.json'),
    );
    log.fine("Markers Count: ${mapController.markers.length}",includeStackTrace: false);
    update();
  }
}
