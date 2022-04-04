import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uber_clone_passenger/app/helpers/routes_manager.dart';

import 'app/pages/signup_page.dart';
import 'app/utils/values.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Values.desingSize,
      minTextAdapt: true,
      splitScreenMode: true,
      child: const SignupPage(),
      builder: (context, home) {
        return MaterialApp(
          title: 'Uber Passenger',
          home: home,
          onGenerateRoute: routesManager,
        );
      },
    );
  }
}
