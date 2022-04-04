import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../exports/pages.dart';
import '../exports/constants.dart';
import '../exports/services.dart';
import '../exports/widgets.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    return ThemeSwitchingArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight * .75,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(Values.radius30)),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: Values.width20, top: Values.height50),
                          child: SizedBox(
                            height: Values.height50,
                            width: Values.height50,
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
                                    if (mounted) {
                                      ThemeSwitcher.of(context).changeTheme(theme: theme);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Values.height20),
                      MyText(
                        text: 'Uber',
                        fontSize: Values.font50,
                        textColor: Coloors.whiteBg,
                      ),
                      MyText(
                        text: 'Get there.',
                        fontSize: Values.font20,
                        textColor: Coloors.whiteBg,
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          'images/bajaj.png',
                          width: 240.w,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * .25,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Values.width20,
                    vertical: Values.height30,
                  ),
                  child: MyElevatedButton(
                    onPressed: navigateToSignupPage,
                    child: const MyText(text: 'Get Started'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToSignupPage() {
    Navigator.of(context).pushNamed(SignupPage.routeName);
  }
}
