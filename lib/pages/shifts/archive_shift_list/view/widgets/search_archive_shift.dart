import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/shifts/archive_shift_list/controller/archive_shift_list_controller.dart';
import 'package:belcka/widgets/textfield/search_text_field_dark.dart';

import '../../../../../utils/string_helper.dart';

class SearchArchiveShift extends StatefulWidget {
  const SearchArchiveShift({super.key});

  @override
  State<SearchArchiveShift> createState() => _SearchArchiveShiftState();
}

class _SearchArchiveShiftState extends State<SearchArchiveShift> {
  final controller = Get.put(ArchiveShiftListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SizedBox(
        height: 46,
        child: SearchTextFieldDark(
          controller: controller.searchController,
          isClearVisible: controller.isClearVisible,
          onValueChange: (value) {
            controller.searchItem(value.toString());
            controller.isClearVisible.value =
                !StringHelper.isEmptyString(value.toString());
          },
          onPressedClear: () {
            controller.searchController.value.clear();
            controller.searchItem("");
            controller.isClearVisible.value = false;
          },
        ),
      ),
    );
  }
}
