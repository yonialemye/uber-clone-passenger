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
      fontFamily: 'Bolt-Reg',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Coloors.darkBg,
      primaryColor: Coloors.blueDark,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Coloors.blueDark.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
        ),
      ),
    );
  }

  static get light {
    return ThemeData(
      fontFamily: 'Bolt-Reg',
      brightness: Brightness.light,
      scaffoldBackgroundColor: Coloors.whiteBg,
      primaryColor: Coloors.blueLight,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Coloors.blueDark.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Coloors.blueLight.withOpacity(0.3)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
        ),
      ),
    );
  }
}
