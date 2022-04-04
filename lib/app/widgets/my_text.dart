import 'package:flutter/material.dart';

import '../exports/constants.dart';

class MyText extends StatelessWidget {
  const MyText({Key? key, required this.text, this.fontSize, this.textColor, this.fontFamily})
      : super(key: key);

  final String text;
  final double? fontSize;
  final Color? textColor;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? Values.font15,
        color: textColor ?? Coloors.whiteBg,
        letterSpacing: 1,
        fontFamily: fontFamily ?? 'Bolt-Bold',
      ),
    );
  }
}
