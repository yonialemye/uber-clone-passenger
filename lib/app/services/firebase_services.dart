import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uber_clone_passenger/app/utils/enums.dart';

import '../../firebase_options.dart';

class FirebaseServices {
  static Future<FirebaseApp> initializeFirebase() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static signupPassenger({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = getCurrentUser();
    if (user == null) return Operation.failed;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('passengers/${user.uid}');
    dbRef.set({
      'full-name': fullName,
      'email-address': email,
      'phone-number': phoneNumber,
    });
    return Operation.success;
  }
}
