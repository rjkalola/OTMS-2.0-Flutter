import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/form_entry_field_renderer.dart';
import 'package:belcka/pages/manage_forms/form_users/view/widgets/form_users_list_item.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormEntryFieldsList extends StatelessWidget {
  FormEntryFieldsList({super.key});

  final controller = Get.find<FormDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (!controller.hasUserEntry.value) {
          return EmptyStateView(
            title: 'no_data_found'.tr,
            message: '',
          );
        }

        if (controller.fields.isEmpty) {
          return EmptyStateView(
            title: 'no_data_found'.tr,
            message: '',
          );
        }

        final entry = controller.userEntry.value;
        if (entry == null) {
          return EmptyStateView(
            title: 'no_data_found'.tr,
            message: '',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 4, bottom: 16),
          itemCount: controller.fields.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return FormUsersListItem(entry: entry);
            }

            return FormEntryFieldRenderer(
              field: controller.fields[index - 1],
            );
          },
        );
      },
    );
  }
}
