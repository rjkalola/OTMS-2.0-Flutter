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

  bool get isCancelled =>
      status == 3 || status == 8 || status == 9;

  int get currentStep {
    if (status == 1 || status == 2 || status == 4) return 0;
    if (status == 5) return 1;
    if (status == 6 || status == 7) return 2;
    return 1; // Cancelled center
  }

  String get lastStepLabel {
    if (status == 7) return 'delivered'.tr;
    if (status == 6) return 'collect'.tr;
    if (status == 5 ||
        status == 1 ||
        status == 2 ||
        status == 4) {
      return 'collect'.tr;
    }
    return "";
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
            showCircle(0,status),
            Expanded(
              child: showDottedLine(0),
            ),
            showCircle(1,status),
            Expanded(
              child: showDottedLine(1),
            ),
            showCircle(2,status),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            showLabel(0, 'preparing'.tr),
            showLabel(1, isCancelled ? 'cancelled'.tr : 'ready'.tr),
            showLabel(2, isCancelled ? "" : lastStepLabel),
          ],
        ),
      ],
    );
  }

  Widget showCircle(int step,int status) {
    Color color;

    if (status == 1){
      color = Colors.grey.shade400;
    }
    else if (isCancelled && step == 1) {
      color = Colors.red;
    } else if (step <= currentStep) {
      color = Colors.blueAccent;
    } else {
      color = Colors.grey.shade400;
    }

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget showDottedLine(int step) {
    Color color;

    if (step < currentStep) {
      color = Colors.blueAccent;
    } else {
      color = Colors.grey.shade400;
    }

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

  Widget showLabel(int step, String text) {
    Color color;

    if (isCancelled && step == 1) {
      color = Colors.red;
    } else if (step <= currentStep) {
      color = Colors.blue;
    } else {
      color = Colors.grey;
    }

    return SizedBox(
      width: 80,
      child: TitleTextView(text: text,
        textAlign: TextAlign.center,
        fontSize: 13,
      ),
    );
  }
}