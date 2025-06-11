import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:otm_inventory/pages/permissions/widgets/controller/widgets_controller.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

import '../../../../../utils/string_helper.dart';

class SearchWidgets extends StatefulWidget {
  const SearchWidgets({super.key});

  @override
  State<SearchWidgets> createState() => _SearchWidgetsState();
}

class _SearchWidgetsState extends State<SearchWidgets> {
  final controller = Get.put(WidgetsController());

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
