import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uber_clone_passenger/app/models/passenger.dart';
import 'package:uber_clone_passenger/app/utils/enums.dart';
import 'package:uber_clone_passenger/app/utils/global_variable.dart';

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
    try {
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
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'Enter a valid email address';
        case 'email-already-in-use':
          return 'This email is taken, try another.';
        default:
          return e.code;
      }
    }
  }

  static loginPassenger({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      final user = getCurrentUser();
      if (user == null) return Operation.failed;

      return Operation.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'Enter a valid email address';
        case 'user-not-found':
          return 'User not found, Use another email.';
        case 'wrong-password':
          return 'Wrong password';
        default:
          return e.code;
      }
    }
  }

  static getCurrentUserInfo() {
    final user = getCurrentUser();
    if (user == null) return;
    String id = user.uid;
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('passengers/$id');
    dbRef.once().then((value) {
      final snapShot = value.snapshot;
      currentUserInfo = Passenger.fromSnapshot(snapShot);
      log(currentUserInfo!.fullName);
    });
  }
}
