import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';

class CreateNewAccount extends StatelessWidget {
  const CreateNewAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 14),
      child: Center(
        child: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.signUp1Screen);
          },
          child: Text('create_new_account'.tr,
              style: const TextStyle(
                color: defaultAccentColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: defaultAccentColor,
              )),
        ),
      ),
    );
  }
}
