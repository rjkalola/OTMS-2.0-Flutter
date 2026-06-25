import 'package:belcka/pages/project/project_analytics/analytics/controller/project_analytics_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectTitleForAnalytics extends StatelessWidget {
  ProjectTitleForAnalytics({super.key});

  final controller = Get.put(ProjectAnalyticsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
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
              ImageUtils.setSvgAssetsImage(
                  path: Drawable.arrowRightCircle,
                  width: 26,
                  height: 26,
                  color: defaultAccentColor_(context))
            ],
          ),
        ),
      ),
    );
  }
}
