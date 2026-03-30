import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final String hintText;
  const StyledTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: backgroundColor_(context),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.0),
        ),
      ),
    );
  }
}