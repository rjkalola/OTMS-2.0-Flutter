import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class JoinCompanyRequestView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  JoinCompanyRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StringHelper.isValidBoolValue(
              controller.dashboardResponse.value.joinCompanyRequest)
          ? Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: PrimaryTextView(
                  text:
                      "Your request to join ${controller.dashboardResponse.value.companyName ?? ""} is not approved yet",
                  color: Colors.red,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  softWrap: true,
                  textAlign: TextAlign.start,
                ),
              ),
            )
          : Container(),
    );
  }
}
