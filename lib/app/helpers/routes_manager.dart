import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uber_clone_passenger/app/pages/signup_page.dart';

Route? routesManager(RouteSettings settings) {
  switch (settings.name) {
    case SignupPage.routeName:
      return PageTransition(
        child: const SignupPage(),
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
