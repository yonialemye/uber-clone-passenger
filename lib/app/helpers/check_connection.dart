import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_clone_passenger/app/utils/enums.dart';

Future<Operation> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com').timeout(
      const Duration(seconds: 2),
    );
    if (!result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Make sure you have an internet connection');
      return Operation.failed;
    }
    return Operation.success;
  } on SocketException catch (_) {
    Fluttertoast.showToast(msg: 'Make sure you have an internet connection');
    return Operation.failed;
  }
}
