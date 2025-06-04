import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

import '../../../../../utils/string_helper.dart';

class SearchCompanyPermissionWidget extends StatefulWidget {
  const SearchCompanyPermissionWidget({super.key});

  @override
  State<SearchCompanyPermissionWidget> createState() =>
      _SearchCompanyPermissionWidgetState();
}

class _SearchCompanyPermissionWidgetState
    extends State<SearchCompanyPermissionWidget> {
  final controller = Get.put(CompanyPermissionController());

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
