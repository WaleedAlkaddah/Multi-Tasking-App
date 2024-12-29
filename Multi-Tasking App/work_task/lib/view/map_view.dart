import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import '../controller/map_con.dart';
import '../controller/search_con.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import '../text/text.dart';
import '../waleed_widget/animated_marker.dart';
import '../waleed_widget/text_field.dart';
import '../waleed_widget/elevated_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController1 controller = Get.find<MapController1>();
  final AddressController addressController = Get.find<AddressController>();
  late final _mapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );

  void onPressedSearch() async {
    await addressController.getAddressInfo();
    setState(() {
      addressController.showCustomMarkers = true;
    });
    _mapController.animateTo(
        dest: addressController.latLng1,
        zoom: 15.0,
        rotation: 15.0,
        curve: Curves.easeIn);
  }

  void onPressedCoordinate() {
    controller.setCoordinate();
    _mapController.animateTo(
        dest: controller.firstMarker,
        zoom: 15.0,
        rotation: 15.0,
        curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController1>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(TextView.addTwoMark),
            actions: [
              OutlinedButton(
                onPressed: () {
                  controller.clearMarkers();
                  addressController.showCustomMarkers = false;
                },
                child: const Text(
                  TextView.clearMarkes,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    TextFieldModified(
                        controller: controller.latController1,
                        text: TextView.latitude1),
                    const SizedBox(width: 10),
                    TextFieldModified(
                        controller: controller.longController1,
                        text: TextView.longitude1),
                  ],
                ),
                ElevatedBtn(
                    url: "",
                    name: TextView.setCoordinate1,
                    onPressedCall: onPressedCoordinate),
                Row(
                  children: [
                    TextFieldModified(
                        controller: controller.latController2,
                        text: TextView.latitude2),
                    const SizedBox(width: 10),
                    TextFieldModified(
                        controller: controller.longController2,
                        text: TextView.longitude2),
                  ],
                ),
                ElevatedBtn(
                    url: "",
                    name: TextView.setCoordinate1,
                    onPressedCall: onPressedCoordinate),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedBtn(
                      url: controller.defultmap,
                      name: TextView.defaultMap,
                      onPressedCall: () =>
                          controller.updateMap(controller.defultmap),
                    ),
                    ElevatedBtn(
                      url: controller.satelliteMap,
                      name: TextView.satelliteMap,
                      onPressedCall: () =>
                          controller.updateMap(controller.satelliteMap),
                    ),
                    ElevatedBtn(
                      url: controller.terrainMap,
                      name: TextView.terrainMap,
                      onPressedCall: () =>
                          controller.updateMap(controller.terrainMap),
                    ),
                  ],
                ),
                TextFieldModified(
                    controller: addressController.textAddressController,
                    text: TextView.enterAddress),
                GetBuilder<AddressController>(builder: (controller) {
                  return ElevatedBtn(
                      url: "",
                      name: TextView.search,
                      onPressedCall: onPressedSearch);
                }),
                const SizedBox(height: 10),
                SizedBox(
                  height: 500,
                  child: FlutterMap(
                    mapController: _mapController.mapController,
                    options: MapOptions(
                        center: const LatLng(0, 0),
                        zoom:  2.0,
                        onTap: (tapPosition, point) {
                          controller.handleTap(tapPosition, point);
                          _mapController.animateTo(
                              dest: point,
                              zoom: 15.0,
                              rotation: 15.0,
                              curve: Curves.easeIn);
                        }),
                    children: [
                      TileLayer(
                        urlTemplate: controller.defultmap,
                      ),
                      AnimatedMarkerLayer(
                        markers: addressController.showCustomMarkers
                            ? [
                                AnimatedMark.buildAnimatedMarker(
                                    LatLng(addressController.latitude.value,
                                        addressController.longitude.value),
                                    'lib/asseets/60.json'),
                              ]
                            : controller.markers,
                      ),
                      PolylineLayer(
                        polylines: [
                          if (controller.firstMarker != null &&
                              controller.secondMarker != null)
                            Polyline(points: [
                              controller.firstMarker!,
                              controller.secondMarker!,
                            ], strokeWidth: 2.0, color: Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: controller.markers.length == 2
              ? FloatingActionButton(
                  onPressed: controller.calculateDistance,
                  child: const Icon(Icons.calculate),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
