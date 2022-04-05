import 'package:flutter/material.dart';

import '../exports/constants.dart';

showLoadingDialog({required BuildContext context, required String text}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Values.height30),
        child: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).textTheme.bodyText2!.color,
              ),
              SizedBox(width: Values.width20),
              Text(text),
            ],
          ),
        ),
      );
    },
  );
}
