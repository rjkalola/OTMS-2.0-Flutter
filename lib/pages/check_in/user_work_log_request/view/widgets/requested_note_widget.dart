import 'package:belcka/pages/check_in/user_work_log_request/controller/user_work_log_request_controller.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class RequestedNoteWidget extends StatelessWidget {
  RequestedNoteWidget({super.key});

  final controller = Get.put(UserWorkLogRequestController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final note = controller.displayNote;
      if (StringHelper.isEmptyString(note)) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: TextFieldBorder(
          textEditingController: TextEditingController(text: note),
          hintText: controller.noteLabel,
          labelText: controller.noteLabel,
          textInputAction: TextInputAction.newline,
          validator: MultiValidator([]),
          isReadOnly: true,
          textAlignVertical: TextAlignVertical.top,
          borderRadius: 16,
        ),
      );
    });
  }
}
