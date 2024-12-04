import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:otm_inventory/utils/image_utils.dart';

import '../utils/string_helper.dart';

class UserImage extends StatelessWidget {
  final String url;
  final double size;
  final String defaultUrl =
      "https://www.pngmart.com/files/22/User-Avatar-Profile-PNG-Isolated-Transparent-Picture.png";

  const UserImage({super.key, required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: ImageUtils.setUserImage(url, size, 45),
    );
  }
}
