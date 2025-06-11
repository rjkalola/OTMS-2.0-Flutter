import 'package:flutter/material.dart';

class BottomLineTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final String? errorText;
  final Color lineColor;
  final Color focusedLineColor;
  final TextInputType keyboardType;
  final int? maxLines; // allow multiple lines

  const BottomLineTextField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.errorText,
    this.lineColor = Colors.grey,
    this.focusedLineColor = Colors.blue,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1, // default to single line
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: lineColor),
        errorText: errorText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: lineColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: focusedLineColor, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}