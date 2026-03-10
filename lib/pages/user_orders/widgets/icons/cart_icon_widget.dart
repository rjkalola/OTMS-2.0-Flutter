import 'package:flutter/material.dart';

class CartIconWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const CartIconWidget({
    super.key,
    this.size = 28,// default size
    this.color, // default color
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.shopping_cart_outlined,
      size: size,
      color: color,
    );
  }
}