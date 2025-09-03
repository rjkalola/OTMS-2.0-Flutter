import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/project/archive_addresses/controller/archive_address_list_controller.dart';
import 'package:belcka/pages/project/archive_projects/controller/archive_project_list_controller.dart';
import 'package:belcka/pages/teams/archive_team_list/controller/archive_team_list_controller.dart';
import 'package:belcka/widgets/textfield/search_text_field_dark.dart';

import '../../../../../utils/string_helper.dart';

class SearchProjectWidget extends StatefulWidget {
  const SearchProjectWidget({super.key});

  @override
  State<SearchProjectWidget> createState() => _SearchProjectWidgetState();
}

class _SearchProjectWidgetState extends State<SearchProjectWidget> {

  final controller = Get.put(ArchiveAddressListController());

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
