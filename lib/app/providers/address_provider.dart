import 'package:flutter/cupertino.dart';

import '../models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  Address? pickUpAddress;

  void setPickUpAddress(Address pickUp) {
    pickUpAddress = pickUp;
    notifyListeners();
  }
}