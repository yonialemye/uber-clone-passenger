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
    this.errorMessage,
    this.readOnly,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType? keyBoardType;
  final String labelText;
  final String? hintText;
  final IconData prefixIcon;
  final String? prefix;
  final String? errorMessage;
  final bool? readOnly;

  String? textFieldValidator(value) {
    if (value == null || value.isEmpty) {
      return 'This field can\'t be empty';
    } else {
      if (keyBoardType == TextInputType.visiblePassword && value.length < 6) {
        return 'Use more than 6 characters for your password';
      } else if (keyBoardType == TextInputType.number &&
          (value.length < 9 ||
              value.length > 10 ||
              !value.toString().startsWith('09') && !value.toString().startsWith('9'))) {
        return 'Use a valid phone number';
      } else if (keyBoardType == TextInputType.text && value.trim().split(' ').length <= 1) {
        return 'Full name must containe at least 2 words';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyBoardType ?? TextInputType.text,
      obscureText: keyBoardType == TextInputType.visiblePassword ? true : false,
      validator: textFieldValidator,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        errorText: errorMessage,
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
