import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';

class CreateNewAccount extends StatelessWidget {
  const CreateNewAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 14),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.signUp1Screen);
          },
          child: Text('create_new_account'.tr,
              style:  TextStyle(
                color: defaultAccentColor_(context),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                decorationColor: defaultAccentColor_(context),
              )),
        ),
      ),
    );
  }
}
