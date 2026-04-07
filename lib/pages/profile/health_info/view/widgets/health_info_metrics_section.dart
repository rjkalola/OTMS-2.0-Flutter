import 'package:belcka/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:belcka/pages/profile/health_info/controller/health_info_controller.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class HealthInfoMetricsSection extends StatelessWidget {
  HealthInfoMetricsSection({super.key});

  final controller = Get.put(HealthInfoController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
              title: 'health_info'.tr,
              fontSize: 18,
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFieldBorderDark(
                    textEditingController: controller.heightController.value,
                    hintText: 'height_cm'.tr,
                    labelText: 'height_cm'.tr,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([]),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      LengthLimitingTextInputFormatter(8),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFieldBorderDark(
                    textEditingController: controller.weightController.value,
                    hintText: 'weight_kg'.tr,
                    labelText: 'weight_kg'.tr,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([]),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      LengthLimitingTextInputFormatter(8),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
