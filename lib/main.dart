import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/exports/constants.dart' show Values;
import 'app/exports/helpers.dart' show routesManager;
import 'app/exports/pages.dart' show SignupPage;

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
          debugShowCheckedModeBanner: false,
          title: 'Uber Passenger',
          home: home,
          onGenerateRoute: routesManager,
        );
      },
    );
  }
}
