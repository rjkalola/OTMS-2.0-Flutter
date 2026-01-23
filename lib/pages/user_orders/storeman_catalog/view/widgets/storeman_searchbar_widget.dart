import 'package:flutter/material.dart';

class StoremanSearchbarWidget extends StatelessWidget {
  const StoremanSearchbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
              Positioned(
                right: 4,
                top: 4,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.green,
                  child: const Text(
                    '2',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}