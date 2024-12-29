import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quick_log/quick_log.dart';

class AddressModel {
  late String address;
  late double latitude;
  late double longitude;
    final log = const Logger("AddressModel");

  AddressModel(
      {required this.address, required this.latitude, required this.longitude});

  Future<void> getAddressInfo(String query) async {
    String apiUrl =
        'https://nominatim.openstreetmap.org/search?format=json&q=$query';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      log.info("Data : $data",includeStackTrace: false);
      if (data != null && data.isNotEmpty) {
        latitude = double.parse(data[0]['lat']);
        longitude = double.parse(data[0]['lon']);
      }
    }
  }
}
