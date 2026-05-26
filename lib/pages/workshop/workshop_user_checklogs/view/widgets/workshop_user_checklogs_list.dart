import 'package:belcka/pages/workshop/workshop_user_checklogs/controller/workshop_user_checklogs_controller.dart';
import 'package:belcka/pages/workshop/workshop_user_checklogs/view/widgets/workshop_user_checklog_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkshopUserChecklogsList extends StatelessWidget {
  WorkshopUserChecklogsList({super.key});

  final controller = Get.find<WorkshopUserChecklogsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.listItems.isEmpty) {
        return Center(child: TitleTextView(text: 'empty_data_message'.tr));
      }

      return ListView.separated(
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final info = controller.listItems[index];
          return Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  child: TitleTextView(
                    text: info.date ?? '',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                ...List.generate(
                  info.data?.length ?? 0,
                  (childIndex) {
                    final logInfo = info.data![childIndex];
                    return WorkshopUserChecklogItem(
                      info: logInfo,
                      onTap: () => controller.moveToChecklogDetails(
                        logInfo.id ?? 0,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
              ],
            ),
          );
        },
        separatorBuilder: (context, _) => const SizedBox(height: 0),
        itemCount: controller.listItems.length,
      );
    });
  }
}
