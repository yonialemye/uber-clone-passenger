import 'package:firebase_database/firebase_database.dart';

class Passenger {
  late String id;
  late String fullName;
  late String email;
  late String phoneNumber;

  Passenger({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  Passenger.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key as String;
    phoneNumber = (snapshot.value as Map)['phone-number'];
    email = (snapshot.value as Map)['email-address'];
    fullName = (snapshot.value as Map)['full-name'];
  }
}
