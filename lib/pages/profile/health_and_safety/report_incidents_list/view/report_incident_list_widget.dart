import 'package:belcka/pages/profile/health_and_safety/attachments_view/attachment_view.dart';
import 'package:belcka/pages/profile/health_and_safety/report_incidents_list/controller/report_incident_list_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/incident_report_card.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/showHSConfirmationDialog.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportIncidentListWidget extends StatefulWidget {
  const ReportIncidentListWidget({super.key});

  @override
  State<ReportIncidentListWidget> createState() => _ReportIncidentListWidgetState();
}

class _ReportIncidentListWidgetState extends State<ReportIncidentListWidget> {
  final controller = Get.put(ReportIncidentListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      itemCount: controller.incidentsReportsList.length,
      itemBuilder: (context, index) {
        final incident = controller.incidentsReportsList[index];
        return IncidentReportCard(
          title: incident.title,
          imageUrl: incident.userThumbImage,
          userName: incident.userName,
          incidentType: incident.incidentType,
          threatLevel: incident.threatLevel,
          date: incident.date,
          files: incident.files,
          onAttachmentTap: () {
            AttachmentSheet.show(context, incident.files);
          },
          onEdit: () {
            var arguments = {"selectedIncidentToEdit": incident,"isEdit":true};
            controller.moveToScreen(AppRoutes.reportIncidentScreen, arguments);
          },
          onDelete: () {
            showHSConfirmationDialog(
              context: context,
              title: "${'delete_incident_report'.tr}?",
              subtitle: "are_you_sure_delete_incident_description",
              confirmText: "delete",
              confirmColor: const Color(0xFFF05261),
              onConfirm: () => controller.deleteReport(incident.id),
            );
          },
        );
      },
    ));
  }
}
