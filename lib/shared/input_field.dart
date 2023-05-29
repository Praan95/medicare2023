// ignore_for_file: avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  final String label;
  final Function(String?) onValidateCallback;
  final Function(String) onChangeCallback;
  final int? maxLength;
  final int maxLines;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final bool readOnly;
  final String initialValue;

  const InputField(
      {required this.label,
      required this.onValidateCallback,
      required this.onChangeCallback,
      required this.initialValue,
      this.maxLength = null,
      this.maxLines = 1,
      this.autofocus = false,
      this.keyboardType = null,
      this.inputFormatters = null,
      this.controller = null,
      this.readOnly = false,
      Key? key})
      : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      initialValue: widget.initialValue,
      style: TextStyle(fontSize: 16),
      controller: widget.controller,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(fontSize: 16),
      ),
      validator: (value) {
        return widget.onValidateCallback(value);
      },
      onChanged: (text) {
        widget.onChangeCallback(text);
      },
    );
  }
}
