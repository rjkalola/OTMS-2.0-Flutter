import 'package:belcka/pages/user_orders/order_details/controller/order_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderActionButtons extends StatelessWidget {
  final int status;
  final VoidCallback? onCancel;
  final VoidCallback? onReturn;
  final VoidCallback? onReorder;
  final String mainTitle;

  const OrderActionButtons({
    super.key,
    required this.status,
    this.onCancel,
    this.onReturn,
    this.onReorder,
    this.mainTitle = "reorder"
  });

  @override
  Widget build(BuildContext context) {
    if (status == 1 || status == 2 || status == 4) {
      return _twoButtons(
        firstTitle: 'cancel'.tr,
        firstColor: Colors.red,
        firstAction: onCancel,
        secondTitle: 'reorder_all'.tr,
        secondColor: Colors.green,
        secondAction: onReorder,
      );
    }

    if (status == 6 || status == 7) {
      return _twoButtons(
        firstTitle: 'return'.tr,
        firstColor: Colors.red,
        firstAction: onReturn,
        secondTitle: 'reorder_all'.tr,
        secondColor: Colors.green,
        secondAction: onReorder,
      );
    }

    return _singleButton(
      title: mainTitle.tr,
      color: Colors.green,
      action: onReorder,
    );
  }

  Widget _twoButtons({
    required String firstTitle,
    required Color firstColor,
    VoidCallback? firstAction,
    required String secondTitle,
    required Color secondColor,
    VoidCallback? secondAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: _actionButton(
            title: firstTitle,
            textColor: firstColor,
            onTap: firstAction,
          ),
        ),
        const Spacer(),
        Expanded(
          child: _actionButton(
            title: secondTitle,
            textColor: secondColor,
            onTap: secondAction,
          ),
        ),
      ],
    );
  }

  Widget _singleButton({
    required String title,
    required Color color,
    VoidCallback? action,
  }) {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            title: title,
            textColor: color,
            onTap: action,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _actionButton({
    required String title,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}