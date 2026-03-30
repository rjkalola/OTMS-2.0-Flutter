import 'package:belcka/pages/user_orders/hire_module/create_hire_order/controller/create_hire_order_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateHireOrderSummarySection extends StatelessWidget {
  final controller = Get.find<CreateHireOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.fromLTRB(24, 4, 8, 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.showProjectList();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleTextView(
                    text: 'project'.tr,
                    fontSize: 16,
                    maxLine: 1,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TitleTextView(
                      text: !StringHelper.isEmptyString(
                              controller.activeProjectTitle.value)
                          ? controller.activeProjectTitle.value
                          : 'select_project'.tr,
                      maxLine: 1,
                      softWrap: true,
                      textAlign: TextAlign.right,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 25,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.showAddressList();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleTextView(
                    text: 'address'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OrdersTitleTextView(
                      text: !StringHelper.isEmptyString(
                              controller.selectedAddressTitle.value)
                          ? controller.selectedAddressTitle.value
                          : 'select_address'.tr,
                      maxLine: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor_(context),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 25,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.showHireFromDatePicker();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleTextView(
                    text: 'hire_from'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TitleTextView(
                      text: controller.hireFromDate.value == null
                          ? 'select_date'.tr
                          : DateUtil.dateToString(
                              controller.hireFromDate.value!,
                              DateUtil.DD_MM_YYYY_SLASH,
                            ),
                      maxLine: 1,
                      softWrap: true,
                      textAlign: TextAlign.right,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 25,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.showHireToDatePicker();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleTextView(
                    text: 'hire_to'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TitleTextView(
                      text: controller.hireToDate.value == null
                          ? 'select_date'.tr
                          : DateUtil.dateToString(
                              controller.hireToDate.value!,
                              DateUtil.DD_MM_YYYY_SLASH,
                            ),
                      maxLine: 1,
                      softWrap: true,
                      textAlign: TextAlign.right,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 25,
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
