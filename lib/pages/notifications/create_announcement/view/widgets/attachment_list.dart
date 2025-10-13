import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/notifications/create_announcement/controller/create_announcement_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/gridview/image_gridview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentList extends StatelessWidget {
  AttachmentList(
      {super.key, required this.onGridItemClick, required this.filesList});

  final Function(int index, String action) onGridItemClick;
  final List<FilesInfo> filesList;
  final controller = Get.put(CreateAnnouncementController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 6, 7, 0),
      child: ImageGridview(
          isEditable: true,
          physics: const NeverScrollableScrollPhysics(),
          filesList: filesList,
          onViewClick: (int index) {
            onGridItemClick(index, AppConstants.action.viewPhoto);
          },
          onRemoveClick: (int index) {
            onGridItemClick(index, AppConstants.action.removePhoto);
          }),
    );
  }
}
