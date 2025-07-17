import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';

class SignUp2NoteTextWidget extends StatelessWidget {
  const SignUp2NoteTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 14, left: 16, right: 16),
      child: Text('upload_photo_note_sign_up'.tr,
          style:  TextStyle(
            color: defaultAccentColor_(context),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          )),
    );
  }
}
