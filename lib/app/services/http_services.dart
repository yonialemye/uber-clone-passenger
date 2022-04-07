import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:uber_clone_passenger/app/exports/constants.dart';

class HttpServices {
  static Future<dynamic> getRequest(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String data = response.body;
        var decodeData = jsonDecode(data);
        return decodeData;
      } else {
        print('you are fucked up');
      }
    } catch (e) {
      log(e.toString());
      return Operation.failed;
    }
  }
}
