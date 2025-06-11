import 'package:flutter/material.dart';
import 'package:otm_inventory/utils/image_utils.dart';

class UserImage extends StatelessWidget {
  final String url;
  final double size;

  const UserImage({super.key, required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: ImageUtils.setUserImage(url: url, width: size, height: size),
    );
  }
}
