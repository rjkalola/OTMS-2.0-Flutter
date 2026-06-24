import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftEarningsCard extends StatelessWidget {
  ShiftEarningsCard({super.key});

  final controller = Get.put(UserStopShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showRate.value || !controller.isShowTotalPayable.value) {
        return const SizedBox.shrink();
      }

      final currency = controller.currency.value;
      final info = controller.workLogInfo.value;
      final totalEarnings = info.totalDayEarnings ?? "0";
      final accent = defaultAccentColor_(context);
      final breakdownRows = _buildBreakdownRows(context, currency, accent);

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      Drawable.stopShiftDollarIcon,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'total_earnings'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: secondaryTextColor_(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$currency$totalEarnings",
                        style: TextStyle( 
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: dividerColor_(context),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: breakdownRows,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildBreakdownRows(
    BuildContext context,
    String currency,
    Color accent,
  ) {
    final info = controller.workLogInfo.value;
    final rows = <Widget>[];

    void addRow(_BreakdownRowData data) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 8));
      rows.add(_BreakdownRow(data: data));
    }

    addRow(_BreakdownRowData(
      label: 'net_payable'.tr,
      amount: "$currency${info.netDayEarnings ?? "0"}",
    ));

    final adjustment = info.totalDayAdjustmentAmount ?? 0;
    if (adjustment != 0) {
      addRow(_BreakdownRowData(
        label: 'adjustment'.tr,
        amount: "$currency$adjustment",
        valueColor: _adjustmentColor(context, adjustment),
      ));
    }

    if ((info.allWorklogsSeconds ?? 0) > 0) {
      addRow(_BreakdownRowData(
        label: 'worklog_summary'.tr,
        amount: "$currency${info.allWorklogsAmount ?? "0"}",
      ));
    }

    final hasPenalty = (info.allPenaltySeconds ?? 0) > 0;
    final penaltyAmount = double.tryParse(info.totalPenaltyAmount ?? "0") ?? 0;
    if (hasPenalty || penaltyAmount != 0) {
      addRow(_BreakdownRowData(
        label: hasPenalty ? 'penalty'.tr : 'penalties'.tr,
        amount: "$currency${info.totalPenaltyAmount ?? "0"}",
        valueColor: hasPenalty ? Colors.red : null,
        onTap: hasPenalty
            ? () {
                final arguments = {
                  AppConstants.intentKey.userId: info.userId ?? 0,
                  AppConstants.intentKey.workLogId: controller.workLogId,
                  AppConstants.intentKey.date: controller.date,
                };
                controller.moveToScreen(AppRoutes.penaltyListScreen, arguments);
              }
            : null,
      ));
    }

    if ((info.allChecklogCount ?? 0) > 0) {
      addRow(_BreakdownRowData(
        label: 'check_in_'.tr,
        amount: '',
        hideAmount: true,
        badgeCount: info.allChecklogCount ?? 0,
        onTap: controller.onTodaysActivityHeaderTap,
      ));
    }

    if ((info.allExpenseCount ?? 0) > 0) {
      addRow(_BreakdownRowData(
        label: 'expense'.tr,
        amount: "$currency${info.allExpenseAmount ?? "0"}",
        badgeCount: info.allExpenseCount ?? 0,
      ));
    }

    if (rows.isNotEmpty) {
      rows.add(const SizedBox(height: 8));
      rows.add(Divider(height: 1, thickness: 1, color: dividerColor_(context)));
      rows.add(const SizedBox(height: 8));
    }

    rows.add(_BreakdownRow(
      data: _BreakdownRowData(
        label: 'total_payable'.tr,
        amount: "$currency${info.totalDayEarnings ?? "0"}",
        isBold: true,
        valueColor: accent,
      ),
    ));

    return rows;
  }

  Color _adjustmentColor(BuildContext context, double adjustment) {
    if (adjustment < 0) return Colors.red;
    if (adjustment > 0) return Colors.green;
    return primaryTextColor_(context);
  }
}

class _BreakdownRowData {
  const _BreakdownRowData({
    required this.label,
    required this.amount,
    this.badgeCount,
    this.valueColor,
    this.isBold = false,
    this.hideAmount = false,
    this.onTap,
  });

  final String label;
  final String amount;
  final int? badgeCount;
  final Color? valueColor;
  final bool isBold;
  final bool hideAmount;
  final VoidCallback? onTap;
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.data});

  final _BreakdownRowData data;

  @override
  Widget build(BuildContext context) {
    final weight = data.isBold ? FontWeight.w600 : FontWeight.w400;
    final labelColor =
        data.isBold ? primaryTextColor_(context) : secondaryTextColor_(context);
    final valueColor = data.valueColor ?? primaryTextColor_(context);

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            data.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: weight,
              color: labelColor,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (!data.hideAmount)
          Text(
            data.amount,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: weight,
              color: valueColor,
            ),
          ),
        if (data.badgeCount != null) ...[
          const SizedBox(width: 4),
          CustomBadgeIcon(
            count: data.badgeCount!,
            color: defaultAccentColor_(context),
          ),
        ],
      ],
    );

    if (data.onTap != null) {
      return GestureDetector(
        onTap: data.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
