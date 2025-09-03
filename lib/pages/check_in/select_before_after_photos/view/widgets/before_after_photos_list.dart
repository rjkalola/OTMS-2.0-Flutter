import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/gridview/image_gridview.dart';

import '../../controller/select_before_after_photos_controller.dart';

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
  final controller = Get.put(SelectBeforeAfterPhotosController());

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(7.0),
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
            }));
  }
}
