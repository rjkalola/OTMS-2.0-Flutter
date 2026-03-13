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

  bool get isCancelled => status == 7;
  bool get isReturned => status == 8;

  int get currentStep {
    // Preparing stage
    if (status == 1 || status == 4 || status == 9) {
      return 0;
    }
    // Middle stage
    if (status == 3 || status == 5 || status == 7) {
      return 1;
    }
    // Final stage
    if (status == 2 || status == 6) {
      return 2;
    }
    return 0;
  }

  String get middleLabel {
    if (status == 7) return 'cancelled'.tr;
    if (status == 8) return 'returned'.tr;
    return 'ready'.tr;
  }

  String get lastStepLabel {
    if (status == 6 || status == 1) {
      return 'delivered'.tr;
    }
    return 'collect'.tr;
  }

  Color getStepColor(int step) {
    // Status 1 → all grey
    if (status == 1) {
      return Colors.grey.shade400;
    }

    // Status 4 → first blue
    if (status == 4) {
      if (step == 0) return Colors.blueAccent;
      return Colors.grey.shade400;
    }

    // Status 3,5,9 → first two blue
    if (status == 3 || status == 5 || status == 9) {
      if (step <= 1) return Colors.blueAccent;
      return Colors.grey.shade400;
    }

    // Status 6,2 → all blue
    if (status == 6 || status == 2) {
      return Colors.blueAccent;
    }

    // Cancelled
    if (status == 7) {
      if (step == 0) return Colors.blueAccent;
      if (step == 1) return Colors.red;
      return Colors.grey.shade400;
    }

    // Returned
    if (status == 8) {
      if (step == 0) return Colors.blueAccent;
      if (step == 1) return Colors.orange;
      return Colors.grey.shade400;
    }

    return Colors.grey.shade400;
  }

  Color getLineColor(int step) {
    if (status == 4 && step == 0) return Colors.blueAccent;

    if ((status == 3 || status == 5 || status == 9) && step == 0) {
      return Colors.blueAccent;
    }

    if (status == 6 || status == 2) {
      return Colors.blueAccent;
    }

    if (status == 7 && step == 0 || status == 8 && step == 0) {
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