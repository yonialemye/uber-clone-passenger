import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../exports/constants.dart';

class ThemeServices {
  ThemeServices._();
  static late SharedPreferences prefs;
  static ThemeServices? _instance;

  static Future<ThemeServices> get instance async {
    if (_instance == null) {
      prefs = await SharedPreferences.getInstance();
      _instance = ThemeServices._();
    }
    return _instance!;
  }

  final allThemes = <String, ThemeData>{
    'dark': Themes.dark,
    'light': Themes.light,
  };

  get previousThemeName {
    String? themeName = prefs.getString('previousThemeName');
    if (themeName == null) {
      final isPlatformDark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      themeName = isPlatformDark ? 'light' : 'dark';
    }
    return themeName;
  }

  get initial {
    String? themeName = prefs.getString('theme');
    if (themeName == null) {
      final isPlatformDark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      themeName = isPlatformDark ? 'dark' : 'light';
    }
    return allThemes[themeName];
  }

  save(String newThemeName) {
    var currentThemeName = prefs.getString('theme');
    if (currentThemeName != null) {
      prefs.setString('previousThemeName', currentThemeName);
    }
    prefs.setString('theme', newThemeName);
  }

  ThemeData getByName(String name) {
    return allThemes[name]!;
  }
}
