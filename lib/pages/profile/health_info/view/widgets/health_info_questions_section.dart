import 'package:belcka/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:belcka/pages/profile/health_info/controller/health_info_controller.dart';
import 'package:belcka/pages/profile/health_info/model/health_issue_form_item.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class HealthInfoQuestionsSection extends StatelessWidget {
  HealthInfoQuestionsSection({super.key});

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
              title: 'health_questions'.tr,
              fontSize: 18,
            ),
            const SizedBox(height: 14),
            Obx(
              () => Column(
                children: controller.issueItems
                    .map((item) => _QuestionTile(item: item))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({required this.item});

  final HealthIssueFormItem item;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HealthInfoController());
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: TextStyle(
              fontSize: 15,
              color: primaryTextColor_(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => RadioGroup<bool>(
              groupValue: item.isYes.value,
              onChanged: (bool? v) => controller.setIssueYesNo(item, v),
              child: Row(
                children: [
                  Text(
                    'yes'.tr,
                    style: TextStyle(color: primaryTextColor_(context)),
                  ),
                  Radio<bool>(
                    value: true,
                    activeColor: defaultAccentColor_(context),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'no'.tr,
                    style: TextStyle(color: primaryTextColor_(context)),
                  ),
                  Radio<bool>(
                    value: false,
                    activeColor: defaultAccentColor_(context),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () {
              if (!item.isYes.value) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextFieldBorderDark(
                  textEditingController: item.commentController,
                  hintText: 'health_detail_note'.tr,
                  labelText: 'health_detail_note'.tr,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 4,
                  borderRadius: 10,
                  minLines: 2,
                  maxLength: 150,
                  validator: MultiValidator([]),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: dividerColor_(context),
          ),
        ],
      ),
    );
  }
}
