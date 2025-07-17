import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border_dark.dart';

import '../../../../../utils/app_constants.dart';

class DisplayNoteWidget extends StatelessWidget {
  DisplayNoteWidget(
      {super.key,
      this.note,
      this.onValueChange,
      this.isReadOnly,
      required this.status});

  final String? note;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;
  final RxInt status;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !StringHelper.isEmptyString(note),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: TextFieldBorder(
            textEditingController: TextEditingController(text: note),
            hintText: getHintText(status.value),
            labelText: getHintText(status.value),
            textInputAction: TextInputAction.newline,
            validator: MultiValidator([]),
            isReadOnly: isReadOnly,
            textAlignVertical: TextAlignVertical.top,
            onValueChange: onValueChange,
            borderRadius: 16,
          ),
        ),
      ),
    );
  }

  String getHintText(int status) {
    if (status == AppConstants.status.rejected) {
      return 'rejected_note'.tr;
    } else if (status == AppConstants.status.approved) {
      return 'approved_note'.tr;
    } else {
      return 'requested_note'.tr;
    }
  }
}
