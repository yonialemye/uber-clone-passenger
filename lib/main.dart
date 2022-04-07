import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/exports/constants.dart' show Themes, Values;
import 'app/exports/helpers.dart' show routesManager;
import 'app/exports/pages.dart';
import 'app/exports/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseServices.initializeFirebase();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Values.desingSize,
      minTextAdapt: true,
      splitScreenMode: true,
      child: const HomePage(),
      builder: (context, home) => AdaptiveTheme(
        light: Themes.light,
        dark: Themes.dark,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Uber Passenger',
            theme: theme,
            darkTheme: darkTheme,
            home: home,
            onGenerateRoute: routesManager,
          );
        },
      ),
    );
  }
}
