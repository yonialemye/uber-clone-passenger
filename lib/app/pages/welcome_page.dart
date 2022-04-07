import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../exports/pages.dart';
import '../exports/constants.dart';
import '../exports/widgets.dart';

class WelcomePage extends StatefulWidget {
  static const String routeName = '/welcome-page';
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool? isDarkMode;

  @override
  void didChangeDependencies() {
    toggleThemeMode();
    isDarkMode == true ? darkStatusAndNavigationBar() : lightStatusAndNavigationBar();
    super.didChangeDependencies();
  }

  toggleThemeMode() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    setState(() {
      if (savedThemeMode == AdaptiveThemeMode.dark) {
        isDarkMode = true;
      } else {
        isDarkMode = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
                          child: DayNightSwitcher(
                            dayBackgroundColor: Coloors.darkBg.withOpacity(0.3),
                            nightBackgroundColor: Coloors.darkBg,
                            isDarkModeEnabled: isDarkMode ?? false,
                            onStateChanged: (value) {
                              setState(() {
                                isDarkMode = value;
                              });
                              if (value) {
                                AdaptiveTheme.of(context).setDark();
                              } else {
                                AdaptiveTheme.of(context).setLight();
                              }
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
                child: Hero(
                  tag: ButtonsHero.elevated,
                  child: MyElevatedButton(
                    onPressed: toSignupPage,
                    child: const MyText(text: 'Get Started'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toSignupPage() => Navigator.of(context).pushNamed(SignupPage.routeName);
}
