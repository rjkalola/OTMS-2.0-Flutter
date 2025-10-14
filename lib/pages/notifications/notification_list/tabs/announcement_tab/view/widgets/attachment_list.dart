import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/controller/announcement_tab_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentList extends StatelessWidget {
  AttachmentList(
      {super.key,
      required this.onGridItemClick,
      required this.filesList,
      required this.parentIndex});

  final Function(int index, String action, int parentIndex) onGridItemClick;
  final List<FilesInfo> filesList;
  final controller = Get.put(AnnouncementTabController());
  final int parentIndex;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !StringHelper.isEmptyList(filesList),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
        child: GridView.builder(
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
                onGridItemClick(
                    index, AppConstants.action.viewPhoto, parentIndex);
              },
              child: DocumentView(
                isEditable: false,
                file: filesList[index].imageUrl ?? "",
                onRemoveClick: () {
                  onGridItemClick(
                      index, AppConstants.action.removePhoto, parentIndex);
                },
              ),
            );
          },
        ),
      ),
    );
    // return Visibility(
    //   visible: !StringHelper.isEmptyList(filesList),
    //   child: Padding(
    //     padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
    //     child: ImageGridview(
    //         isEditable: false,
    //         physics: const NeverScrollableScrollPhysics(),
    //         filesList: filesList,
    //         onViewClick: (int index) {
    //           onGridItemClick(
    //               index, AppConstants.action.viewPhoto, parentIndex);
    //         },
    //         onRemoveClick: (int index) {
    //           onGridItemClick(
    //               index, AppConstants.action.removePhoto, parentIndex);
    //         }),
    //   ),
    // );
  }
}
