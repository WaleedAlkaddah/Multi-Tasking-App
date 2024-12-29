import 'package:get/get.dart';
import '../controller/map_con.dart';
import '../controller/search_con.dart';

class MapBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController1>(() => MapController1());
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
