import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

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
          color: defaultAccentColor_(context),
          fontSize: 16,
        ),
      ),
    );
  }
}
