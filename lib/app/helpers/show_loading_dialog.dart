import 'package:flutter/material.dart';

import '../exports/constants.dart';

showLoadingDialog({
  required BuildContext context,
  String? text,
  Color? barrierColor,
  Color? backGroundColor,
  Color? loadingColor,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: barrierColor,
    builder: (context) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Values.height30),
        child: AlertDialog(
          elevation: 0,
          backgroundColor: backGroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: loadingColor ?? Theme.of(context).textTheme.bodyText2!.color,
              ),
              SizedBox(width: Values.width20),
              if (text != null) Text(text),
            ],
          ),
        ),
      );
    },
  );
}
