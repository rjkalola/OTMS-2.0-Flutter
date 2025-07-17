import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';

class DoNotHaveAnAccountWidget extends StatelessWidget {
  const DoNotHaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 0),
      child: Center(
        child: Text('do_not_have_an_account'.tr,
            style:  TextStyle(
              color: secondaryLightTextColor_(context),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }
}
