import 'package:flutter/material.dart';

import '../res/colors.dart';

class FooterPrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const FooterPrimaryButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        color: defaultAccentColor_(context),
        elevation: 0,
        height: 50,
        splashColor: Colors.white.withAlpha(30),
        child: Text(buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            )),
      ),
    );
  }
}
