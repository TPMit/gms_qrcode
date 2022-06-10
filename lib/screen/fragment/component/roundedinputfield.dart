// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:gms_mobile/screen/fragment/component/textfieldcontainer.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final ValueChanged<String> onChanged;
  final double? width;
  final TextInputType? inputType;
  const RoundedInputField(
      {Key? key,
      required this.hintText,
      this.icon,
      required this.onChanged,
      this.width,
      this.inputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: null != width ? width : null,
      child: TextField(
        keyboardType: inputType != null ? inputType : null,
        onChanged: onChanged,
        cursorColor: Colors.teal.shade300,
        decoration: InputDecoration(
          icon: Icon(
            icon != null ? icon : null,
            color: Colors.teal.shade600,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
