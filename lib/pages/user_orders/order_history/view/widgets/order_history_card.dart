import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryCard extends StatelessWidget {
  final String orderNumber;
  final String amount;
  final String date;
  final int status;

  const OrderHistoryCard({
    super.key,
    required this.orderNumber,
    required this.amount,
    required this.date,
    required this.status,
  });

  bool get isCancelled => status == AppConstants.internalOrderStatus.cancelled;
  bool get isReturned => status == AppConstants.internalOrderStatus.returned;

  int get currentStep {
    // Preparing stage
    if (status == AppConstants.internalOrderStatus.newOrder ||
        status == AppConstants.internalOrderStatus.preparing ||
        status == AppConstants.internalOrderStatus.confirmed)
    {
      return 0;
    }
    // Middle stage
    if (status == AppConstants.internalOrderStatus.rejected ||
        status == AppConstants.internalOrderStatus.ready ||
        status == AppConstants.internalOrderStatus.cancelled)
    {
      return 1;
    }
    // Final stage
    if (status == AppConstants.internalOrderStatus.collected ||
        status == AppConstants.internalOrderStatus.delivered ||
        status == AppConstants.internalOrderStatus.partialDelivered)
    {
      return 2;
    }

    return 0;
  }

  String get middleLabel {
    if (status == AppConstants.internalOrderStatus.cancelled) return 'cancelled'.tr;
    if (status == AppConstants.internalOrderStatus.returned) return 'returned'.tr;
    return 'ready'.tr;
  }

  String get lastStepLabel {
    if (status == AppConstants.internalOrderStatus.delivered) {
      return 'delivered'.tr;
    }
    if (status == AppConstants.internalOrderStatus.partialDelivered) {
      return 'partially_delivered'.tr;
    }
    return 'collected'.tr;
  }

  Color getStepColor(int step) {
    // Status 1 → all grey
    if (status == AppConstants.internalOrderStatus.newOrder) {
      return Colors.grey.shade400;
    }

    // Status 4 → first blue
    if (status == AppConstants.internalOrderStatus.preparing) {
      if (step == 0) return Colors.blueAccent;
      return Colors.grey.shade400;
    }

    // Status 3,5,9 → first two blue
    if (status == AppConstants.internalOrderStatus.rejected ||
        status == AppConstants.internalOrderStatus.ready ||
        status == AppConstants.internalOrderStatus.confirmed)
    {
      if (step <= 1) return Colors.blueAccent;
      return Colors.grey.shade400;
    }

    // Status 6,2 → all blue
    if (status == AppConstants.internalOrderStatus.delivered ||
        status == AppConstants.internalOrderStatus.collected ||
        status == AppConstants.internalOrderStatus.partialDelivered) {
      return Colors.blueAccent;
    }

    // Cancelled
    if (status == AppConstants.internalOrderStatus.cancelled) {
      if (step == 0) return Colors.blueAccent;
      if (step == 1) return Colors.red;
      return Colors.grey.shade400;
    }

    // Returned
    if (status == AppConstants.internalOrderStatus.returned) {
      if (step == 0) return Colors.blueAccent;
      if (step == 1) return Colors.orange;
      return Colors.grey.shade400;
    }

    return Colors.grey.shade400;
  }

  Color getLineColor(int step) {
    if (status == AppConstants.internalOrderStatus.preparing && step == 0) return Colors.blueAccent;

    if ((status == AppConstants.internalOrderStatus.rejected ||
        status == AppConstants.internalOrderStatus.ready ||
        status == AppConstants.internalOrderStatus.confirmed) && step == 0) {
      return Colors.blueAccent;
    }

    if (status == AppConstants.internalOrderStatus.delivered ||
        status == AppConstants.internalOrderStatus.collected ||
        status == AppConstants.internalOrderStatus.partialDelivered) {
      return Colors.blueAccent;
    }

    if (status == AppConstants.internalOrderStatus.cancelled && step == 0 || status == AppConstants.internalOrderStatus.returned && step == 0) {
      return Colors.blueAccent;
    }

    return Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleTextView(
                text: "${'order'.tr}: $orderNumber",
                  fontSize: 16,
                  fontWeight: FontWeight.w700
              ),
              SubtitleTextView(
                text: date,
                fontSize: 14,
              ),
            ],
          ),

          const SizedBox(height: 4),

          TitleTextView(
            text: "${'total_amount'.tr}: $amount",
              fontSize: 14
          ),

          const SizedBox(height: 20),
          showProgressView(),
        ],
      ),
    );
  }

  Widget showProgressView() {
    return Column(
      children: [
        Row(
          children: [
            showCircle(0, status),
            Expanded(
              child: showDottedLine(0),
            ),
            showCircle(1, status),
            Expanded(
              child: showDottedLine(1),
            ),
            showCircle(2, status),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [

            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: showLabel(
                  0,
                  'preparing'.tr,
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: showLabel(
                  1,
                  status == 7
                      ? 'cancelled'.tr
                      : status == 8
                      ? 'returned'.tr
                      : 'ready'.tr,
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: showLabel(
                  2,
                  (status == 7 || status == 8) ? '' : lastStepLabel,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget showCircle(int step, int status) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: getStepColor(step),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget showLabel(int step, String text) {
    return TitleTextView(
      text: text,
      textAlign: TextAlign.center,
      fontSize: 13,
    );
  }

  Widget showDottedLine(int step) {

    Color color = getLineColor(step);

    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 10.0;
        final dashCount = (constraints.maxWidth / (dashWidth * 2)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1.2,
              color: color,
            );
          }),
        );
      },
    );
  }
}