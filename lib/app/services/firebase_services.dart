import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

class FirebaseServices {
  static Future<FirebaseApp> initializeFirebase() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
