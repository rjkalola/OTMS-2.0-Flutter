import 'package:belcka/pages/profile/health_and_safety/near_miss_list/controller/near_miss_list_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/near_miss_card.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/showHSConfirmationDialog.dart';

class NearMissListWidget extends StatefulWidget {
  const NearMissListWidget({super.key});

  @override
  State<NearMissListWidget> createState() => _NearMissListWidgetState();
}

class _NearMissListWidgetState extends State<NearMissListWidget> {
  final controller = Get.put(NearMissListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: controller.nearMissReportsList.length,
      itemBuilder: (context, index) {
        final report = controller.nearMissReportsList[index];

        return NearMissCard(
          imageUrl: report.addedByUserThumbImage ?? "",
          userName: report.addedByUserName ?? "",
          reportDescription: report.description ?? "",
          hazardType: report.hazardName ?? "",
          hasAttachment: report.hasAttachments,
          files: report.files,
          onEdit: () {
            var arguments = {"selectedReportToEdit": report,"isEdit":true};
            controller.moveToScreen(AppRoutes.nearMissReportingScreen, arguments);
          },
          onDelete: () {
            showHSConfirmationDialog(
              context: context,
              title: "${'delete_near_miss_report'.tr}?",
              subtitle: "are_you_sure_delete_near_miss_description",
              confirmText: "delete",
              confirmColor: const Color(0xFFF05261),
              onConfirm: () => controller.deleteReport(report.id),
            );
          },
          onAttachmentTap: (){
            print("show attachments");
          },
        );
      },
    ));
  }
}
