import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_clone_passenger/app/exports/constants.dart';
import 'package:uber_clone_passenger/app/exports/helpers.dart';

import '../utils/api_keys.dart';
import 'http_services.dart';

class HomePageServices {
  static Future<String> findCoordinateAddress(Position position) async {
    String placeAddress = '';
    final status = await checkConnection();
    if (status == Operation.failed) {
      Fluttertoast.showToast(msg: 'Make sure you have an internet connection');
      return placeAddress;
    }
    String url = '${Values.url}${position.latitude},${position.longitude}&key=$mapApiKey';
    var response = await HttpServices.getRequest(url);
    if (response != Operation.failed) {
      placeAddress = response['results'][0]['formatted_address'];
    }
    return placeAddress;
  }
}
