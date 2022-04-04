import 'package:flutter/material.dart';
import 'package:uber_clone_passenger/app/exports/constants.dart';

class MyElevatedButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final VoidCallback onPressed;

  const MyElevatedButton({Key? key, required this.child, this.color, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Values.height50 - 2,
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          splashFactory: NoSplash.splashFactory,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}
