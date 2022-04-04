import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;

import '../exports/constants.dart';

void darkStatusAndNavigationBar() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Coloors.darkBg,
      systemNavigationBarDividerColor: Coloors.darkBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
}

void lightStatusAndNavigationBar() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Coloors.whiteBg,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

class Themes {
  static get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Coloors.darkBg,
      primaryColor: Coloors.blueDark,
    );
  }

  static get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Coloors.whiteBg,
      primaryColor: Coloors.blueLight,
    );
  }
}
