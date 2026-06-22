import 'package:belcka/pages/manage_forms/submit_form/controller/submit_form_controller.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/form_field_renderer.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/form_validation_banner.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormFieldsList extends StatelessWidget {
  FormFieldsList({super.key});

  final controller = Get.find<SubmitFormController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.fields.isEmpty) {
          return EmptyStateView(
            title: 'no_data_found'.tr,
            message: '',
          );
        }

        final showBanner = controller.showValidationErrors.value;

        return ListView.builder(
          padding: const EdgeInsets.only(top: 0, bottom: 8),
          itemCount: controller.fields.length + (showBanner ? 1 : 0),
          itemBuilder: (context, index) {
            if (showBanner && index == 0) {
              return const FormValidationBanner();
            }

            final fieldIndex = showBanner ? index - 1 : index;
            return FormFieldRenderer(field: controller.fields[fieldIndex]);
          },
        );
      },
    );
  }
}
