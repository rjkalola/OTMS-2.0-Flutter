import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/gridview/image_gridview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/type_of_work_details_controller.dart';

class BeforeAfterPhotosList extends StatelessWidget {
  BeforeAfterPhotosList(
      {super.key,
      required this.onGridItemClick,
      required this.filesList,
      this.photosType,
      this.isEditable});

  final Function(int index, String action, String photosType) onGridItemClick;
  final List<FilesInfo> filesList;
  final String? photosType;
  final bool? isEditable;
  final controller = Get.put(TypeOfWorkDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
      child: ImageGridview(
          isEditable: isEditable,
          filesList: filesList,
          onViewClick: (int index) {
            onGridItemClick(
                index, AppConstants.action.viewPhoto, photosType ?? "");
          },
          onRemoveClick: (int index) {
            if ((filesList[index].id ?? 0) > 0) {
              controller.removeIds.add(filesList[index].id.toString());
            }
            onGridItemClick(
                index, AppConstants.action.removePhoto, photosType ?? "");
          }),
    );
  }
}
