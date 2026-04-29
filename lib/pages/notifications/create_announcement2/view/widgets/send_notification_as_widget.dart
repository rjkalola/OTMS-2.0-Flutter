import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/create_announcement_controller.dart';

class SendNotificationAsWidget extends StatelessWidget {
  SendNotificationAsWidget({super.key});

  final controller = Get.put(CreateAnnouncementController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: PrimaryTextView(
              text: "${'send_notification_as'.tr}:",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 9,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              children: [
                Radio<String>(
                  value: "company",
                  groupValue: controller.sendNotificationAs.value,
                  activeColor: defaultAccentColor_(context),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  onChanged: (value) {
                    if (value != null) {
                      controller.sendNotificationAs.value = "company";
                    }
                  },
                ),
                GestureDetector(
                    onTap: () {
                      controller.sendNotificationAs.value = "company";
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: TitleTextView(
                        text: 'company'.tr,
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Radio<String>(
                  value: "admin",
                  groupValue: controller.sendNotificationAs.value,
                  activeColor: defaultAccentColor_(context),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  onChanged: (value) {
                    if (value != null) {
                      controller.sendNotificationAs.value = "admin";
                    }
                  },
                ),
                GestureDetector(
                    onTap: () {
                      controller.sendNotificationAs.value = "admin";
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: TitleTextView(
                        text: 'admin'.tr,
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
