import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';

import '../../../../../utils/app_constants.dart';

class CheckOutDisplayNoteWidget extends StatelessWidget {
  CheckOutDisplayNoteWidget({super.key, this.note, required this.isCheckedOut});

  final String? note;
  final RxBool isCheckedOut;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !StringHelper.isEmptyString(note),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
          child: TextFieldBorder(
            textEditingController: TextEditingController(text: note),
            hintText:
                isCheckedOut.value ? 'check_out_note'.tr : 'check_in_note'.tr,
            labelText:
                isCheckedOut.value ? 'check_out_note'.tr : 'check_in_note'.tr,
            textInputAction: TextInputAction.newline,
            validator: MultiValidator([]),
            isReadOnly: true,
            textAlignVertical: TextAlignVertical.top,
            // onValueChange: null,
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
