import 'package:flutter/material.dart';

class BookmarkIconWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const BookmarkIconWidget({
    super.key,
    this.size = 28,// default size
    this.color, // default color
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.bookmark_outline,
      size: size,
      color: color,
    );
  }
}