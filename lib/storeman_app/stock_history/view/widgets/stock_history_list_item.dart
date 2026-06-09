import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/stock_history/controller/stock_history_controller.dart';
import 'package:belcka/storeman_app/stock_history/model/stock_history_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockHistoryListItem extends StatelessWidget {
  final StockHistoryInfo item;

  const StockHistoryListItem({super.key, required this.item});

  String _formatQtyChange(double value) {
    if (value > 0) {
      return '+${AppUtils.formatDecimalNumber(value)}';
    }
    return AppUtils.formatDecimalNumber(value);
  }

  String _subQtyText() {
    if (item.isSubQty != true || item.packOffQty == null) return '';
    final unit = item.packOffName ?? '';
    final packQty = item.packOffQty!.trim();
    if (packQty.isEmpty) return '';
    return '($packQty $unit)';
  }

  String _amountText() {
    if (item.totalAmount == null) return '';
    final amount = AppUtils.formatDecimalNumber(item.totalAmount!);
    return '${item.currency ?? ''}$amount';
  }

  String _noteOrUserText() {
    if (item.hasNote) return item.note!.trim();
    if (!StringHelper.isEmptyString(item.userName)) return item.userName!;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockHistoryController>();
    final qtyColor = item.isInMovement
        ? const Color(0xFF2E7D32)
        : item.isOutMovement
            ? const Color(0xFFE53935)
            : primaryTextColor_(context);
    final noteText = _noteOrUserText();
    final adjustedStock = '${_formatQtyChange(item.qtyValue)}${_subQtyText()}';

    return GestureDetector(
      onTap: item.hasNote
          ? () => controller.showNoteDialog(item.note!.trim())
          : null,
      child: CardViewDashboardItem(
        borderRadius: 14,
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: PrimaryTextView(
                    text: item.date ?? '',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                PrimaryTextView(
                  text: item.uuid ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: secondaryLightTextColor_(context),
                ),
              ],
            ),
            if (!StringHelper.isEmptyString(item.name)) ...[
              const SizedBox(height: 6),
              TitleTextView(
                text: item.name ?? '',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                maxLine: 2,
              ),
            ],
            if (noteText.isNotEmpty) ...[
              const SizedBox(height: 6),
              SubtitleTextView(
                text: noteText,
                fontSize: 14,
                maxLine: 1,
                color: primaryTextColor_(context),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: PrimaryTextView(
                    text: '${'amount'.tr}: ${_amountText()}',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                PrimaryTextView(
                  text: '${'stock_in_hand'.tr}: ${item.newQty ?? ''}',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            const SizedBox(height: 4),
            PrimaryTextView(
              text: '${'adjusted_stock'.tr}: $adjustedStock',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: qtyColor,
            ),
          ],
        ),
      ),
    );
  }
}
