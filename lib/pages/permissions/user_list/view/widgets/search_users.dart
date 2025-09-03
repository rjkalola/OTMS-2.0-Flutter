import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:belcka/pages/permissions/permission_users/controller/permission_users_controller.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/search_text_field.dart';


class SearchUsersWidget extends StatefulWidget {
  const SearchUsersWidget({super.key});

  @override
  State<SearchUsersWidget> createState() =>
      _SearchUsersWidgetState();
}

class _SearchUsersWidgetState
    extends State<SearchUsersWidget> {
  final controller = Get.put(UserListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SizedBox(
        height: 46,
        child: SearchTextField(
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
