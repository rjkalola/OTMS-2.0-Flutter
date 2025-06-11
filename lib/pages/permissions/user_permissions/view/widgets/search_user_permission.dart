import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/controller/user_permission_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

import '../../../../../utils/string_helper.dart';

class SearchUserPermissionWidget extends StatefulWidget {
  const SearchUserPermissionWidget({super.key});

  @override
  State<SearchUserPermissionWidget> createState() =>
      _SearchUserPermissionWidgetState();
}

class _SearchUserPermissionWidgetState
    extends State<SearchUserPermissionWidget> {
  final controller = Get.put(UserPermissionController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SizedBox(
        height: 46,
        child: SearchTextField(
          label: 'search_user'.tr,
          controller: controller.searchController,
          isClearVisible: controller.isClearVisible,
          isReadOnly: true,
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
          onTap: () {
            controller.moveToSearchUSer();
          },
        ),
      ),
    );
  }
}
