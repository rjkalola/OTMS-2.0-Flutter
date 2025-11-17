import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/expense/add_expense/controller/add_expense_controller.dart';
import 'package:belcka/pages/notifications/create_announcement/controller/create_announcement_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/gridview/document_gridview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpensePhotosList extends StatelessWidget {
  ExpensePhotosList(
      {super.key, required this.onGridItemClick, required this.filesList});

  final Function(int index, String action) onGridItemClick;
  final List<FilesInfo> filesList;
  final controller = Get.put(AddExpenseController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(7, 6, 7, 0),
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
