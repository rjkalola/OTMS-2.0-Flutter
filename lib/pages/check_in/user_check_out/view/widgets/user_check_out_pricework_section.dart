import 'package:belcka/pages/check_in/user_check_out/controller/user_check_out_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserCheckOutPriceworkSection extends StatelessWidget {
  UserCheckOutPriceworkSection({super.key});

  final controller = Get.put(UserCheckOutController());

  static TextStyle _valueStyle(BuildContext context) => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: primaryTextColor_(context),
      );

  static TextStyle _valueHintStyle(BuildContext context) => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: secondaryTextColor_(context),
      );

  @override
  Widget build(BuildContext context) {
    final isEditable = StringHelper.isEmptyString(
        controller.checkLogInfo.value.checkoutDateTime);

    return Obx(() {
      final currency = controller.currencySymbol.value;
      final totalText = controller.formattedTotalPayment;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FieldCard(
            iconPath: Drawable.checkinTradeIcon,
            title: 'work_type'.tr,
            child: TextField(
              controller: controller.workTypeController.value,
              readOnly: !isEditable,
              style: _valueStyle(context),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'work_type'.tr,
                hintStyle: _valueHintStyle(context),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _FieldCard(
                  iconPath: Drawable.checkinTradeIcon,
                  title: 'amount_in_currency'.trParams({'currency': currency}),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        currency,
                        style: _valueStyle(context),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller.amountController.value,
                          readOnly: !isEditable,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textAlignVertical: TextAlignVertical.center,
                          strutStyle: StrutStyle.fromTextStyle(
                            _valueStyle(context),
                            forceStrutHeight: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          onChanged: (_) => controller.updateTotalPayment(),
                          style: _valueStyle(context),
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: _valueHintStyle(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: isEditable ? controller.showSelectUnitDialog : null,
                  behavior: HitTestBehavior.opaque,
                  child: _FieldCard(
                    iconPath: Drawable.checkinTradeIcon,
                    title: 'unit'.tr,
                    showIcon: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            StringHelper.isEmptyString(
                                    controller.unitController.value.text)
                                ? 'unit'.tr
                                : controller.unitController.value.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _valueStyle(context).copyWith(
                              color: StringHelper.isEmptyString(
                                      controller.unitController.value.text)
                                  ? secondaryTextColor_(context)
                                  : primaryTextColor_(context),
                            ),
                          ),
                        ),
                        if (isEditable)
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: secondaryTextColor_(context),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _FieldCard(
            iconPath: Drawable.checkinTradeIcon,
            title: 'work_completed'.tr,
            child: TextField(
              controller: controller.workCompletedController.value,
              readOnly: !isEditable,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => controller.updateTotalPayment(),
              style: _valueStyle(context),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: '0',
                hintStyle: _valueHintStyle(context),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${'total_payment'.tr} : $totalText',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: primaryTextColor_(context),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({
    required this.iconPath,
    required this.title,
    required this.child,
    this.showIcon = true,
  });

  final String iconPath;
  final String title;
  final Widget child;
  final bool showIcon;

  static const Color _iconBg = Color(0xFFE8F8EE);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: showIcon
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: ImageUtils.setSvgAssetsImage(
                      path: iconPath,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor_(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      child,
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor_(context),
                  ),
                ),
                const SizedBox(height: 8),
                child,
              ],
            ),
    );
  }
}
