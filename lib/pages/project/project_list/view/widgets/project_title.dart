import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../project_list/controller/project_list_controller.dart';

class ProjectTitle extends StatelessWidget {
  ProjectTitle({super.key});

  final controller = Get.put(ProjectListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: GestureDetector(
        onTap: () {
          controller.showActiveProjectDialogDialog();
        },
        child: Row(
          children: [
            Flexible(
              child: PrimaryTextView(
                text: !StringHelper.isEmptyString(
                    controller.activeProjectTitle.value)
                    ? controller.activeProjectTitle.value
                    : 'select_project'.tr,
                softWrap: true,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              decoration: AppUtils.getGrayBorderDecoration(
                  borderColor: defaultAccentColor_(context),
                  borderWidth: 1,
                  radius: 45),
              alignment: Alignment.center,
              width: 26,
              height: 26,
              child: RightArrowWidget(
                size: 26,
                color: defaultAccentColor_(context),
              ),
            )
          ],
        ),
      ),
    ),);
  }
}
