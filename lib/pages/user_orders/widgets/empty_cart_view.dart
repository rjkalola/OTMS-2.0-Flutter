import 'package:belcka/pages/user_orders/widgets/icons/cart_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyCartView extends StatelessWidget {
  final VoidCallback? onOrderNow;

  const EmptyCartView({super.key, this.onOrderNow});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cart Icon
            CartIconWidget(size: 40,),
            const SizedBox(height: 20),
            // Title
            Text('empty_basket_msg'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            // Subtitle
            Text(
              "${'empty_basket_sub_msg'.tr}.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),
            /*
            // Order now Button
            ElevatedButton(
              onPressed: onOrderNow,
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Start Shopping"),
            ),
            */
          ],
        ),
      ),
    );
  }
}