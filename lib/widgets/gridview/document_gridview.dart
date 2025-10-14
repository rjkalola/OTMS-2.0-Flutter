import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentGridview extends StatelessWidget {
  const DocumentGridview(
      {super.key,
      required this.filesList,
      required this.onViewClick,
      required this.onRemoveClick,
      this.physics,
      this.fileRadius,
      this.isEditable});

  final List<FilesInfo> filesList;
  final ValueChanged<int> onViewClick;
  final ValueChanged<int> onRemoveClick;
  final ScrollPhysics? physics;
  final double? fileRadius;
  final bool? isEditable;

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: physics,
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
                onViewClick(index);
              },
              child: DocumentView(
                isEditable: isEditable,
                file: filesList[index].imageUrl ?? "",
                onRemoveClick: () {
                  onRemoveClick(index);
                },
              ),
            );
          },
        ));
  }
}

class CloseClick {
  final ValueChanged<int> callback;

  CloseClick(this.callback);
}
