import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class DoItLater extends StatelessWidget {
  DoItLater({super.key});

  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          controller.moveToDashboard();
        },
        child: PrimaryTextView(
          text: 'do_it_later'.tr.toUpperCase(),
          color: defaultAccentColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
