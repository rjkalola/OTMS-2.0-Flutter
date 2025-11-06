import 'package:belcka/pages/project/project_list/view/widgets/address_filter_list.dart';
import 'package:belcka/pages/project/project_list/view/widgets/project_title.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/project_list_controller.dart';

class ProjectListHeaderView extends StatelessWidget {
  ProjectListHeaderView({super.key});

  final controller = Get.put(ProjectListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
          border: Border.all(width: 0.6, color: Colors.transparent),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28)),
        ),
        child: Column(
          children: [
            ProjectTitle(),
            Visibility(
              visible: !StringHelper.isEmptyString(
                  controller.activeProjectTitle.value),
              child: SizedBox(
                height: 14,
              ),
            ),
            Visibility(
                visible: !StringHelper.isEmptyString(
                    controller.activeProjectTitle.value),
                child: AddressFilterList()),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
