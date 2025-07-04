import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';

class LogInNote2TextWidget extends StatelessWidget {
  const LogInNote2TextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 14, left: 20, right: 20),
      child: Text('log_in_note2'.tr,
          style: const TextStyle(
            color: primaryTextColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )),
    );
  }
}
