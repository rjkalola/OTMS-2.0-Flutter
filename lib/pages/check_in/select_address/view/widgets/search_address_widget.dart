import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/select_address/controller/select_address_controller.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

class SearchAddressWidget extends StatefulWidget {
  const SearchAddressWidget({super.key});

  @override
  State<SearchAddressWidget> createState() => _SearchAddressWidgetState();
}

class _SearchAddressWidgetState extends State<SearchAddressWidget> {
  final controller = Get.put(SelectAddressController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: SizedBox(
        height: 44,
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
