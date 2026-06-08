import 'package:belcka/storeman_app/edit_stock/controller/edit_stock_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class EditStockFooter extends StatelessWidget {
  final EditStockController controller;

  const EditStockFooter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(height: 1, color: dividerColor_(context)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: controller.isReferenceMode.value
                      ? TextFieldBorderDark(
                          textEditingController: controller.referenceController,
                          hintText: 'reference'.tr,
                          labelText: 'reference'.tr,
                          textInputAction: TextInputAction.done,
                          borderRadius: 8,
                          validator: MultiValidator([]),
                        )
                      : DropDownTextField(
                          title: 'select_user'.tr,
                          controller: controller.userController,
                          onPressed: controller.showSelectUserDialog,
                          borderRadius: 8,
                        ),
                ),
                const SizedBox(width: 8),
                _ToggleIconButton(
                  icon: controller.isReferenceMode.value
                      ? Icons.person_outline
                      : Icons.description_outlined,
                  onTap: controller.toggleReferenceUserMode,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: SubtitleTextView(
                text: _hintText(controller),
                fontSize: 13,
                color: secondaryExtraLightTextColor_(context),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'deduct'.tr,
                    borderColor: Colors.red,
                    textColor: Colors.red,
                    onTap: controller.onDeductPressed,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _QuantityField(controller: controller),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    label: 'add'.tr,
                    borderColor: Colors.green,
                    textColor: Colors.green,
                    onTap: controller.onAddPressed,
                  ),
                ),
              ],
            ),
            if (controller.product.isSubQty == true) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.togglePackMode,
                  child: Text(
                    controller.isPackMode.value
                        ? 'deduct_quantity_from_pack'.tr
                        : 'add_a_pack'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: controller.isPackMode.value
                          ? Colors.red
                          : defaultAccentColor_(context),
                    ),
                  ),
                ),
              ),
            ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _hintText(EditStockController controller) {
    if (controller.product.isSubQty == true && controller.isPackMode.value) {
      return 'enter_number_below_to_deduct_from_pack'.tr;
    }
    return 'adjust_qty'.tr;
  }
}

class _ToggleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ToggleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: dividerColor_(context)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 22, color: primaryTextColor_(context)),
      ),
    );
  }
}

class _QuantityField extends StatelessWidget {
  final EditStockController controller;

  const _QuantityField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final showUnit = controller.product.isSubQty == true &&
        !controller.isPackMode.value &&
        !StringHelper.isEmptyString(controller.product.packOfUnit);
    final unit = showUnit ? controller.product.packOfUnit! : '';

    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: normalTextFieldBorderDarkColor_(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextField(
            controller: controller.qtyController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.center,
            onChanged: controller.onQtyChanged,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 15,
              color: primaryTextColor_(context),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'quantity'.tr,
              hintStyle: TextStyle(
                fontSize: 15,
                color: hintColor_(context),
              ),
              isDense: true,
              contentPadding:
                  EdgeInsets.fromLTRB(showUnit ? 12 : 8, 0, showUnit ? 28 : 8, 0),
            ),
          ),
          if (showUnit)
            Positioned(
              right: 10,
              child: Text(
                unit,
                style: TextStyle(
                  color: defaultAccentColor_(context),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
