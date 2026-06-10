import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/phone_length_formatter.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class FormPhoneFieldView extends StatefulWidget {
  const FormPhoneFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  State<FormPhoneFieldView> createState() => _FormPhoneFieldViewState();
}

class _FormPhoneFieldViewState extends State<FormPhoneFieldView> {
  late final FormDetailsController _controller;
  late final String _fieldId;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FormDetailsController>();
    _fieldId = widget.field.id ?? '';
    _phoneController = TextEditingController(
      text: _controller.getPhoneNumber(_fieldId),
    );
    _phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    _controller.setPhoneNumber(_fieldId, _phoneController.text);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        _controller.phoneValues[_fieldId];
        final phoneValue = _controller.getPhoneValue(_fieldId);
        final hasError = _controller.showValidationErrors.value &&
            _controller.isFieldInvalid(_fieldId);

        return CardViewDashboardItem(
          borderRadius: widget.isNested ? 12 : 16,
          margin: widget.isNested
              ? const EdgeInsets.symmetric(horizontal: 4)
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
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextFieldPhoneExtensionWidget(
                      mExtension: phoneValue?.extension ?? '',
                      mFlag: phoneValue?.flag ?? '',
                      onPressed: () =>
                          _controller.showPhoneExtensionDialog(_fieldId),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 3,
                    child: TextFieldBorder(
                      textEditingController: _phoneController,
                      hintText: 'phone'.tr,
                      labelText: 'phone'.tr,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      validator: MultiValidator([]),
                      onValueChange: (value) =>
                          _controller.setPhoneNumber(_fieldId, value),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        PhoneLengthFormatter(),
                      ],
                    ),
                  ),
                ],
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
