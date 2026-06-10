import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormTaskFieldView extends StatelessWidget {
  const FormTaskFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  static const double _controlSize = 22;
  static const double _leadingInset = -2;
  static const double _controlTextGap = 6;
  static const double _textStartPadding =
      _controlSize + _controlTextGap + _leadingInset;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final fieldId = field.id ?? '';
    final compactTheme = Theme.of(context).copyWith(
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return Obx(
      () {
        final hasError = controller.showValidationErrors.value &&
            controller.isFieldInvalid(fieldId);
        final isChecked = controller.isTaskChecked(fieldId);

        return CardViewDashboardItem(
          borderRadius: isNested ? 12 : 16,
          margin: isNested
              ? const EdgeInsets.symmetric(horizontal: 4)
              : const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => controller.setTaskChecked(
                  fieldId,
                  !isChecked,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(_leadingInset, 0),
                      child: SizedBox(
                        width: _controlSize,
                        height: _controlSize,
                        child: Theme(
                          data: compactTheme,
                          child: Transform.scale(
                            scale: 0.9,
                            alignment: Alignment.center,
                            child: Checkbox(
                              value: isChecked,
                              activeColor: defaultAccentColor_(context),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: const VisualDensity(
                                horizontal: -4,
                                vertical: -4,
                              ),
                              onChanged: (value) =>
                                  controller.setTaskChecked(fieldId, value),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: _controlTextGap),
                    Expanded(
                      child: Text(
                        field.label ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryTextColor_(context),
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasError && field.isRequired) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: _textStartPadding),
                  child: Text(
                    'this_field_is_required'.tr,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: rejectTextColor_(context),
                    ),
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
