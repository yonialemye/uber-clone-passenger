import 'package:flutter/material.dart';

import '../exports/widgets.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        splashFactory: NoSplash.splashFactory,
      ),
      child: MyText(
        text: text,
        textColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
