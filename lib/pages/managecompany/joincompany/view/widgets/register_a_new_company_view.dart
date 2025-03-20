import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class RegisterANewCompanyView extends StatelessWidget {
  const RegisterANewCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 30),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
            buttonText: 'register_a_new_company'.tr.toUpperCase(),
            onPressed: () {}),
      ),
    );
  }
}
