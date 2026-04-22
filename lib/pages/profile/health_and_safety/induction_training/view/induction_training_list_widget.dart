import 'package:belcka/pages/profile/health_and_safety/attachments_view/attachment_view.dart';
import 'package:belcka/pages/profile/health_and_safety/induction_training/controller/induction_training_list_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/induction_training_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InductionTrainingListWidget extends StatefulWidget {
  const InductionTrainingListWidget({super.key});

  @override
  State<InductionTrainingListWidget> createState() => _InductionTrainingListWidgetState();
}

class _InductionTrainingListWidgetState extends State<InductionTrainingListWidget> {
  final controller = Get.put(InductionTrainingListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(

      itemCount: controller.inductionTrainingList.length,
      itemBuilder: (context, index) {
        final induction = controller.inductionTrainingList[index];
        return InductionTrainingCard(
            imageUrl: induction.addedByUserThumbImage,
            userName: induction.addedByName,
            trainingTitle: induction.title,
            description: induction.description,
            teamNames: induction.teams.map((t) => t.name).toList(),
            hasAttachment: induction.files.isNotEmpty,
            onAttachmentTap: (){
            AttachmentSheet.show(context, induction.files);
          },
        );
      },
    ));
  }
}
