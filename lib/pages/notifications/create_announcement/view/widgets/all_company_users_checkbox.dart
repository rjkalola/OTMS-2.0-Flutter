import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/create_announcement_controller.dart';

class AllCompanyUsersCheckbox extends StatelessWidget {
  AllCompanyUsersCheckbox({super.key});

  final controller = Get.put(CreateAnnouncementController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
        child: InkWell(
          onTap: () {
            controller.isCompanyUsers.value = !controller.isCompanyUsers.value;
          },
          borderRadius: BorderRadius.circular(22),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor_(context),
                  border: Border.all(
                    color: controller.isCompanyUsers.value
                        ? defaultAccentColor_(context)
                        : const Color(0xffDDDDDD),
                    width: controller.isCompanyUsers.value ? 2.5 : 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TitleTextView(
                  text: 'all_company_users'.tr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
