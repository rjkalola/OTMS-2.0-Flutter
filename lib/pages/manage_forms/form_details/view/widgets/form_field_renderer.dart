import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_type.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_dropdown_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_group_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_unsupported_field_view.dart';
import 'package:flutter/material.dart';

/// Dispatches each field type to its dedicated preview widget.
/// Implemented: [FormFieldType.dropdown], [FormFieldType.group]
/// Pending: description, formula, open ended, scanner, location,
/// task, rating, image upload, file upload, phone, number, yes/no,
/// image selection, audio recording, date, signature, video upload,
/// numbers slider, email.
class FormFieldRenderer extends StatelessWidget {
  const FormFieldRenderer({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    if (field.showOnlyIf != true) {
      return _buildField();
    }

    final controller = Get.find<FormDetailsController>();
    return Obx(() {
      if (!controller.isFieldVisible(field)) {
        return const SizedBox.shrink();
      }
      return _buildField();
    });
  }

  Widget _buildField() {
    switch (field.normalizedType) {
      case FormFieldType.dropdown:
        return FormDropdownFieldView(field: field, isNested: isNested);
      case FormFieldType.group:
        return FormGroupFieldView(field: field);
      default:
        return FormUnsupportedFieldView(field: field, isNested: isNested);
    }
  }
}
