import 'package:belcka/pages/user_orders/order_history/view/widgets/dashed_line_painter.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class OrderProgress extends StatelessWidget {
  final int activeIndex;
  final String lastLabel;

  const OrderProgress({
    super.key,
    required this.activeIndex,
    required this.lastLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 26,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: CustomPaint(
                    painter: DashedLinePainter(activeIndex),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  return orderProgressDot(index <= activeIndex);
                }),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OrdersTitleTextView(text: "Preparing",fontSize: 14,),
            OrdersTitleTextView(text: "Ready",fontSize: 14),
            OrdersTitleTextView(text: lastLabel,fontSize: 14),
          ],
        )
      ],
    );
  }

  Widget orderProgressDot(bool active) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: active ? Colors.blueAccent : Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
    );
  }
}