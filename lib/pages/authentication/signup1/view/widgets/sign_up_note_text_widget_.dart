import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';

class SignUpNoteTextWidget extends StatelessWidget {
  const SignUpNoteTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 14, left: 16, right: 16),
      child: Text('sign_up_free_and_start_using_otm_system'.tr,
          style: const TextStyle(
            color: defaultAccentColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          )),
    );
  }
}
