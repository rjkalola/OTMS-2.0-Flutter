import 'package:flutter/material.dart';

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
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              "Your Basket is Empty",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Subtitle
            Text(
              "Looks like you haven't added anything yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
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