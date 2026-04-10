import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller; // Add this

  const StyledTextField({
    super.key,
    required this.hintText,
    required this.controller, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,),
      controller: controller, // Assign the controller here
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        filled: true,
        fillColor: backgroundColor_(context),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(color: defaultAccentColor_(context), width: 1.5),
        ),
      ),
    );
  }
}