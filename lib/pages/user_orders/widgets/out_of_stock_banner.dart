import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class OutOfStockBanner extends StatelessWidget {
  final int itemCount;
  final int deliveryDays;

  const OutOfStockBanner({
    super.key,
    required this.itemCount,
    required this.deliveryDays,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount <= 0) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: primaryTextColor_(context),
                  fontSize: 14,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "$itemCount items ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  //const TextSpan(text: "are out of stock; they will be delivered within "),
                  const TextSpan(text: "are out of stock; they will be delivered soon. "),
                  /*
                  TextSpan(
                    text: "$deliveryDays working days",
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: "."),
                  */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}