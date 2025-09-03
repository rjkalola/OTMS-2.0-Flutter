import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/signup2/controller/signup2_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';

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
            fontColor: defaultAccentColor_(context),
            borderColor: defaultAccentColor_(context),
            onPressed: () {
              controller.onSignUpClick();
            },
          )),
    );
  }
}
