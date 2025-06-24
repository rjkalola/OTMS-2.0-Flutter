import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/select_shift/controller/select_shift_controller.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:otm_inventory/pages/permissions/permission_users/controller/permission_users_controller.dart';
import 'package:otm_inventory/pages/shifts/shift_list/controller/shift_list_controller.dart';
import 'package:otm_inventory/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:otm_inventory/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/textfield/search_text_field_dark.dart';

import '../../../../../utils/string_helper.dart';

class SearchShift extends StatefulWidget {
  const SearchShift({super.key});

  @override
  State<SearchShift> createState() => _SearchShiftState();
}

class _SearchShiftState extends State<SearchShift> {
  final controller = Get.put(SelectShiftController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 5, 14, 10),
      child: SizedBox(
        height: 46,
        child: SearchTextFieldDark(
          controller: controller.searchController,
          isClearVisible: controller.isClearVisible,
          hint: 'Search shift...',
          label: 'Search shift...',
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
