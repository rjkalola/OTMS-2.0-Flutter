import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup2/controller/signup2_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';

class RegisterButtonWidget extends StatelessWidget {
  RegisterButtonWidget({super.key});

  final controller = Get.put(SignUp2Controller());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: PrimaryBorderButton(
            buttonText: 'register'.tr,
            fontColor: defaultAccentColor,
            borderColor: defaultAccentColor,
            onPressed: () {
              controller.onSignUpClick();
            },
          )),
    );
  }
}
