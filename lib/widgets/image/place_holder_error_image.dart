import 'package:flutter/material.dart';

class PlaceHolderErrorImage extends StatelessWidget {
  const PlaceHolderErrorImage({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.photo_outlined, size: size);
  }
}
