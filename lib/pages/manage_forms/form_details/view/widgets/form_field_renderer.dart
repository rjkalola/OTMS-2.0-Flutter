import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_type.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_audio_recording_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_date_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_description_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_dropdown_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_email_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_file_upload_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_formula_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_group_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_image_selection_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_image_upload_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_location_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_number_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_numbers_slider_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_open_ended_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_phone_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_rating_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_scanner_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_signature_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_task_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_video_upload_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_yes_no_field_view.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/fields/form_unsupported_field_view.dart';
import 'package:flutter/material.dart';

/// Dispatches each field type to its dedicated preview widget.
/// Implemented: [FormFieldType.dropdown], [FormFieldType.group],
/// [FormFieldType.openEnded], [FormFieldType.location], [FormFieldType.task],
/// [FormFieldType.rating], [FormFieldType.phone], [FormFieldType.yesNo],
/// [FormFieldType.date], [FormFieldType.numbersSlider], [FormFieldType.email],
/// [FormFieldType.description], [FormFieldType.number], [FormFieldType.formula],
/// [FormFieldType.signature], [FormFieldType.imageUpload],
/// [FormFieldType.videoUpload], [FormFieldType.scanner],
/// [FormFieldType.imageSelection], [FormFieldType.fileUpload],
/// [FormFieldType.audioRecording]
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
      case FormFieldType.openEnded:
        return FormOpenEndedFieldView(field: field, isNested: isNested);
      case FormFieldType.location:
        return FormLocationFieldView(field: field, isNested: isNested);
      case FormFieldType.task:
        return FormTaskFieldView(field: field, isNested: isNested);
      case FormFieldType.rating:
        return FormRatingFieldView(field: field, isNested: isNested);
      case FormFieldType.phone:
        return FormPhoneFieldView(field: field, isNested: isNested);
      case FormFieldType.yesNo:
        return FormYesNoFieldView(field: field, isNested: isNested);
      case FormFieldType.date:
        return FormDateFieldView(field: field, isNested: isNested);
      case FormFieldType.numbersSlider:
        return FormNumbersSliderFieldView(field: field, isNested: isNested);
      case FormFieldType.email:
        return FormEmailFieldView(field: field, isNested: isNested);
      case FormFieldType.number:
        return FormNumberFieldView(field: field, isNested: isNested);
      case FormFieldType.formula:
        return FormFormulaFieldView(field: field, isNested: isNested);
      case FormFieldType.signature:
        return FormSignatureFieldView(field: field, isNested: isNested);
      case FormFieldType.imageUpload:
        return FormImageUploadFieldView(field: field, isNested: isNested);
      case FormFieldType.videoUpload:
        return FormVideoUploadFieldView(field: field, isNested: isNested);
      case FormFieldType.scanner:
        return FormScannerFieldView(field: field, isNested: isNested);
      case FormFieldType.imageSelection:
        return FormImageSelectionFieldView(field: field, isNested: isNested);
      case FormFieldType.fileUpload:
        return FormFileUploadFieldView(field: field, isNested: isNested);
      case FormFieldType.audioRecording:
        return FormAudioRecordingFieldView(field: field, isNested: isNested);
      case FormFieldType.description:
        return FormDescriptionFieldView(field: field, isNested: isNested);
      case FormFieldType.group:
        return FormGroupFieldView(field: field);
      default:
        return FormUnsupportedFieldView(field: field, isNested: isNested);
    }
  }
}
