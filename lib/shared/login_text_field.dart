import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginTextField extends StatelessWidget {
  LoginTextField(
      {Key? key,
      required this.labelText,
      required this.onChanged,
      this.obscureText = false})
      : super(key: key);

  void Function(String) onChanged;
  bool obscureText;
  String labelText;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Colors.teal,
      borderRadius: BorderRadius.circular(25),
      child: TextFormField(
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
                // borderSide: const BorderSide(color: Colors.black, width: 0),
                borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
