import 'package:flutter/material.dart';

import '../../res/colors.dart';

class TextFieldPhoneExtensionWidget extends StatelessWidget {
  const TextFieldPhoneExtensionWidget(
      {super.key, this.mFlag = "", this.mExtension = "", this.onPressed});

  final String? mFlag, mExtension;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: TextFormField(
        onTap: () {
          onPressed!();
        },
        style: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: primaryTextColor),
        readOnly: true,
        controller: TextEditingController(text: mExtension),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          prefixIcon: Image.network(
            mFlag ?? "",
            width: 32,
            height: 32,
          ),
          suffixIcon: const Icon(Icons.arrow_drop_down),
          counterText: "",
          contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: focusedTextFieldBorderColor, width: 1),
            borderRadius: BorderRadius.circular(45.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: focusedTextFieldBorderColor, width: 1),
            borderRadius: BorderRadius.circular(45.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: normalTextFieldBorderColor, width: 1),
            borderRadius: BorderRadius.circular(45.0),
          ),
          hintText: "Extension",
          labelText: "Extension",
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
        ),
      ),
      onTap: () {
        onPressed!();
      },
    );
  }
}
