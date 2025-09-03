import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:belcka/pages/permissions/permission_users/controller/permission_users_controller.dart';
import 'package:belcka/widgets/search_text_field.dart';

import '../../../../../utils/string_helper.dart';

class SearchPermissionUsersWidget extends StatefulWidget {
  const SearchPermissionUsersWidget({super.key});

  @override
  State<SearchPermissionUsersWidget> createState() =>
      _SearchPermissionUsersWidgetState();
}

class _SearchPermissionUsersWidgetState
    extends State<SearchPermissionUsersWidget> {
  final controller = Get.put(PermissionUsersController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SizedBox(
        height: 46,
        child: SearchTextField(
          hint: 'search_user'.tr,
          label: 'search_user'.tr,
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
