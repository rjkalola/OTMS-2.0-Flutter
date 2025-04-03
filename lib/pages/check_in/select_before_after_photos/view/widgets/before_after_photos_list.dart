import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/common/model/file_info.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/widgets/gridview/image_gridview.dart';

class BeforeAfterPhotosList extends StatelessWidget {
  BeforeAfterPhotosList(
      {super.key,
      required this.onGridItemClick,
      required this.filesList,
      this.photosType});

  final Function(int index, String action, String photosType) onGridItemClick;
  final List<FilesInfo> filesList;
  final String? photosType;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(7.0),
        child: ImageGridview(
            filesList: filesList,
            onViewClick: (int index) {
              onGridItemClick(
                  index, AppConstants.action.viewPhoto, photosType ?? "");
            },
            onRemoveClick: (int index) {
              onGridItemClick(
                  index, AppConstants.action.removePhoto, photosType ?? "");
            }));
  }
}
