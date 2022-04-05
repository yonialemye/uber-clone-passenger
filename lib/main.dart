import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/exports/constants.dart' show Values;
import 'app/exports/helpers.dart' show routesManager;
import 'app/exports/pages.dart' show WelcomePage;
import 'app/exports/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseServices.initializeFirebase();
  final themeServise = await ThemeServices.instance;
  var initTheme = themeServise.initial;
  runApp(MyApp(theme: initTheme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Values.desingSize,
      minTextAdapt: true,
      splitScreenMode: true,
      child: const WelcomePage(),
      builder: (context, home) {
        return ThemeProvider(
          initTheme: theme,
          builder: (_, theme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Uber Passenger',
            theme: theme,
            home: home,
            onGenerateRoute: routesManager,
          ),
        );
      },
    );
  }
}
