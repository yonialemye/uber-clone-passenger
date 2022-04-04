import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';

import '../exports/constants.dart';
import '../exports/services.dart';

class WelcomePage extends StatefulWidget {
  static const String routeName = '/welcome-page';
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isDarkModeEnabled(context) {
    final animatedSwitch = ThemeModelInheritedNotifier.of(context);
    final isDarkMode = animatedSwitch.theme.brightness == Brightness.light ? false : true;
    return isDarkMode;
  }

  @override
  void didChangeDependencies() {
    final isDarkMode = Theme.of(context).scaffoldBackgroundColor == Coloors.whiteBg;
    isDarkMode ? lightStatusAndNavigationBar() : darkStatusAndNavigationBar();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(right: 20),
              child: ThemeSwitcher(
                builder: (context) {
                  return DayNightSwitcher(
                    dayBackgroundColor: Coloors.darkBg.withOpacity(0.3),
                    nightBackgroundColor: Coloors.darkBg,
                    isDarkModeEnabled: isDarkModeEnabled(context),
                    onStateChanged: (value) async {
                      var themeName = value ? 'dark' : 'light';
                      var service = await ThemeServices.instance
                        ..save(themeName);
                      var theme = service.getByName(themeName);
                      if (mounted) ThemeSwitcher.of(context).changeTheme(theme: theme);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
