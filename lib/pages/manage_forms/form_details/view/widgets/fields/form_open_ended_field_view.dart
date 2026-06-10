import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormOpenEndedFieldView extends StatefulWidget {
  const FormOpenEndedFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  State<FormOpenEndedFieldView> createState() => _FormOpenEndedFieldViewState();
}

class _FormOpenEndedFieldViewState extends State<FormOpenEndedFieldView> {
  late final TextEditingController _textController;
  late final FormDetailsController _controller;
  late final String _fieldId;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FormDetailsController>();
    _fieldId = widget.field.id ?? '';
    _textController = TextEditingController(
      text: _controller.getTextValue(_fieldId),
    );
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _controller.setTextValue(_fieldId, _textController.text);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final hasError = _controller.showValidationErrors.value &&
            _controller.isFieldInvalid(_fieldId);

        return CardViewDashboardItem(
          borderRadius: widget.isNested ? 12 : 16,
          margin: widget.isNested
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormFieldLabel(
                label: widget.field.label ?? '',
                isRequired: widget.field.isRequired,
              ),
              if (!StringHelper.isEmptyString(widget.field.description)) ...[
                const SizedBox(height: 4),
                SubtitleTextView(
                  text: widget.field.description!,
                  fontSize: 14,
                  color: secondaryExtraLightTextColor_(context),
                  maxLine: 4,
                ),
              ],
              const SizedBox(height: 10),
              TextField(
                controller: _textController,
                minLines: 4,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: primaryTextColor_(context),
                  height: 1.35,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'enter_your_answer'.tr,
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: hintColor_(context),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: normalTextFieldBorderColor_(context),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: normalTextFieldBorderColor_(context),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: focusedTextFieldBorderColor_(context),
                    ),
                  ),
                ),
              ),
              if (hasError && widget.field.isRequired) ...[
                const SizedBox(height: 6),
                Text(
                  'this_field_is_required'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: rejectTextColor_(context),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
