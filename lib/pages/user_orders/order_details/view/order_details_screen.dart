import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _orderHeader(context),
              const SizedBox(height: 16),
              _productList(),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HEADER CARD ----------------
  Widget _orderHeader(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              children: [
                const Icon(Icons.arrow_back_ios, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "Order R1053",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("£870.00",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("21 item",
                        style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),

            /// Store Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.store, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Camden Voids",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text("18 Ashington, NW5 4RG",
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text("Ready, 14.10.25 15:32",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.chat_bubble_outline,
                    color: Colors.blue),
              ],
            ),

            const SizedBox(height: 16),

            /// Buttons
            Row(
              children: [
                _outlineButton("Cancel / Return", Colors.red),
                const SizedBox(width: 12),
                _outlineButton("Reorder All", Colors.green),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _productList() {
    final products = [
      {
        "title": "ElectriQ 60cm 4 Zone Indu Cut XXXXXXX",
        "code": "DCK1234",
        "qty": "1",
        "price": "£180.00",
        "image": Icons.kitchen
      },
      {
        "title": "ElectriQ 60cm 4 Zone Indu Cut XXXXXXX",
        "code": "DCK1234",
        "qty": "2",
        "price": "£200.00",
        "image": Icons.kitchen_outlined
      },
      {
        "title": "ElectriQ 60cm 4 Zone Induction Hob",
        "code": "DCK1234",
        "qty": "4",
        "price": "£150.00",
        "image": Icons.circle
      },
      {
        "title": "Twyford Alcona Close Coupled Toilet Pan",
        "code": "DCK1234",
        "qty": "2",
        "price": "£70.00",
        "image": Icons.wc
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = products[index];
        return Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item["image"] as IconData,
                      size: 32, color: Colors.black54),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item["title"] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(item["code"] as String,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("Qty: ${item["qty"]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(item["price"] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Reorder"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _outlineButton(String text, Color color) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: Text(text),
      ),
    );
  }
}