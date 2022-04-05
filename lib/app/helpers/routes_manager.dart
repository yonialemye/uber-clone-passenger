import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../exports/pages.dart';

Route? routesManager(RouteSettings settings) {
  switch (settings.name) {
    case WelcomePage.routeName:
      return PageTransition(
        child: const WelcomePage(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      );
    case SignupPage.routeName:
      return PageTransition(
        child: const SignupPage(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      );
    case LoginPage.routeName:
      return PageTransition(
        child: const LoginPage(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      );
    case HomePage.routeName:
      return PageTransition(
        child: const HomePage(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('No PageRoute Provided'),
          ),
        ),
      );
  }
}
