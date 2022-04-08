import 'package:flutter/cupertino.dart';

import '../models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  Address? pickUpAddress;
  Address? destinationAddress;

  void setPickUpAddress(Address pickUp) {
    pickUpAddress = pickUp;
    notifyListeners();
  }

  void setDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }
}
