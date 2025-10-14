import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/notifications/create_announcement/controller/create_announcement_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/gridview/document_gridview.dart';
import 'package:belcka/widgets/gridview/image_gridview.dart';
import 'package:belcka/widgets/image/document_view.dart';
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
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(7, 6, 7, 0),
        /*  child: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (1 / 1),
              crossAxisCount: 4, // number of items in each row
              mainAxisSpacing: 7.0, // spacing between rows
              crossAxisSpacing: 7.0, // spacing between columns
            ),
            padding: const EdgeInsets.all(8.0),
            // padding around the grid
            itemCount: filesList.length,
            // total number of items
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  onGridItemClick(index, AppConstants.action.viewPhoto);
                },
                child: Stack(
                  children: [
                    DocumentView(
                      isEditable: true,
                      file: filesList[index].imageUrl ?? "",
                      onRemoveClick: () {
                        onGridItemClick(index, AppConstants.action.removePhoto);
                      },
                    )
                  ],
                ),
              );
            },
          )*/
        child: DocumentGridview(
            isEditable: true,
            physics: const NeverScrollableScrollPhysics(),
            filesList: filesList.obs,
            onViewClick: (int index) {
              onGridItemClick(index, AppConstants.action.viewPhoto);
            },
            onRemoveClick: (int index) {
              onGridItemClick(index, AppConstants.action.removePhoto);
            }),
      ),
    );
  }
}
