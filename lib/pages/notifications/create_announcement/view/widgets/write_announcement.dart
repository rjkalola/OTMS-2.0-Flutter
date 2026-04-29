import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

class WriteAnnouncement extends StatelessWidget {
  const WriteAnnouncement(
      {super.key,
      required this.controller,
      this.onValueChange,
      this.isReadOnly});

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardShadowColor = isDark
        ? Colors.black.withValues(alpha: 0.30)
        : Colors.black.withValues(alpha: 0.08);
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: cardShadowColor,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextFieldBorder(
            textEditingController: controller.value,
            autovalidateMode: AutovalidateMode.disabled,
            hintText: 'write_announcement_placeholder'.tr,
            labelText: 'write_announcement_placeholder'.tr,
            borderRadius: 22,
            textInputAction: TextInputAction.newline,
            validator: MultiValidator([]),
            isReadOnly: isReadOnly,
            textAlignVertical: TextAlignVertical.top,
            onValueChange: onValueChange,
            minLines: 6,
            maxLines: 12,
          ),
        ),
      ),
    );
  }
}
