import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_passenger/app/exports/constants.dart';
import 'package:uber_clone_passenger/app/exports/helpers.dart';
import 'package:uber_clone_passenger/app/providers/address_provider.dart';

import '../models/address_model.dart';
import '../utils/api_keys.dart';
import 'http_services.dart';

class HomePageServices {
  static Future<Operation> locationPermissionHandler() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    return Operation.success;
  }

  static Future<String> findCoordinateAddress({
    required Position position,
    required BuildContext context,
    required bool mounted,
  }) async {
    String placeAddress = '';
    String placeId = '';
    final status = await checkConnection();
    if (status == Operation.failed) {
      Fluttertoast.showToast(msg: 'Make sure you have an internet connection');
      return placeAddress;
    }
    String url = '${Values.url}${position.latitude},${position.longitude}&key=$mapApiKey';
    var response = await HttpServices.getRequest(url);
    if (response != Operation.failed) {
      placeAddress = response['results'][0]['formatted_address'];
      placeId = response['results'][0]['place_id'];
    }

    Address address = Address(
      placeName: placeAddress,
      placeAddressId: placeId,
      latitude: position.latitude,
      longitude: position.longitude,
    );

    if (mounted) Provider.of<AddressProvider>(context, listen: false).updatePickUpAddress(address);
    return placeAddress;
  }
}
