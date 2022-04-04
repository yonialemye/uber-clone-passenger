import 'package:flutter/material.dart';

import '../exports/constants.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.controller,
    this.keyBoardType,
    required this.labelText,
    this.hintText,
    required this.prefixIcon,
    this.prefix,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType? keyBoardType;
  final String labelText;
  final String? hintText;
  final IconData prefixIcon;
  final String? prefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyBoardType ?? TextInputType.text,
      obscureText: keyBoardType == TextInputType.visiblePassword ? true : false,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        prefix: prefix != null ? Text(prefix!) : null,
        labelText: labelText,
        hintText: hintText,
        fillColor: Coloors.blueDark.withOpacity(0.08),
        filled: true,
        isDense: true,
      ),
    );
  }
}
