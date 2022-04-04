import 'package:flutter/material.dart';
import 'package:uber_clone_passenger/app/helpers/routes_manager.dart';

import 'app/pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Uber Passenger',
      home: SignupPage(),
      onGenerateRoute: routesManager,
    );
  }
}
