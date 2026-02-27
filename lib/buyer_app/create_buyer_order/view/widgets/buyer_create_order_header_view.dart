import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_tabs.dart';
import 'package:belcka/buyer_app/create_buyer_order/controller/create_buyer_order_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';

class BuyerCreateOrderHeaderView extends StatelessWidget {
  BuyerCreateOrderHeaderView({super.key});

  final controller = Get.put(CreateBuyerOrderController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFieldBorderDark(
                textEditingController: controller.orderIdController.value,
                hintText: 'order_id'.tr,
                labelText: 'order_id'.tr,
                isReadOnly: false,
                maxLength: 6,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onValueChange: (value) {},
                validator: MultiValidator([
                  RequiredValidator(errorText: 'required_field'.tr),
                  MinLengthValidator(6,
                      errorText: 'order_length_validation_message'.tr),
                ]),
                inputFormatters: <TextInputFormatter>[
                  // for below version 2 use this
                  FilteringTextInputFormatter.digitsOnly,
                ]),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: DropDownTextField(
              title: 'expected_delivery_date'.tr,
              controller: controller.expectedDeliveryController,
              validators: [
                RequiredValidator(errorText: 'required_field'.tr),
              ],
              onPressed: () {
                controller.showDatePickerDialog(
                    AppConstants.dialogIdentifier.selectDate,
                    controller.expectedDeliveryDate,
                    DateTime.now(),
                    DateTime(2060));
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: DropDownTextField(
              title: 'store'.tr,
              controller: controller.storeController,
              validators: [
                RequiredValidator(errorText: 'required_field'.tr),
              ],
              onPressed: () {
                controller.showSelectStoreDialog();
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: DropDownTextField(
              title: 'supplier'.tr,
              controller: controller.supplierController,
              validators: [
                RequiredValidator(errorText: 'required_field'.tr),
              ],
              onPressed: () {
                controller.showSelectSupplierDialog();
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFieldBorderDark(
              textEditingController: controller.refController.value,
              hintText: 'ref'.tr,
              labelText: 'ref'.tr,
              textInputAction: TextInputAction.newline,
              textAlignVertical: TextAlignVertical.top,
              validator: MultiValidator([]),
              maxLength: 150,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFieldBorderDark(
              textEditingController: controller.noteController.value,
              hintText: 'note'.tr,
              labelText: 'note'.tr,
              textInputAction: TextInputAction.newline,
              textAlignVertical: TextAlignVertical.top,
              maxLength: 150,
              validator: MultiValidator([]),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
