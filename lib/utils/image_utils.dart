import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../pages/common/widgets/image_preview_dialog.dart';

class ImageUtils {
  static String defaultUserAvtarUrl =
      "https://www.pngmart.com/files/22/User-Avatar-Profile-PNG-Isolated-Transparent-Picture.png";

  static Widget setUserImage(String url, double size, double radius) {
    return !StringHelper.isEmptyString(url)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: size,
              height: size,
              errorBuilder: (context, url, error) => Image.network(
                defaultUserAvtarUrl,
                fit: BoxFit.scaleDown,
                height: size,
                width: size,
              ),
            ),
          )
        : Image.network(
            defaultUserAvtarUrl,
            fit: BoxFit.scaleDown,
            height: size,
            width: size,
          );
  }

  static Widget setImage(String url, double size) {
    return !StringHelper.isEmptyString(url)
        ? Image.network(
            url,
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorBuilder: (context, url, error) =>
                Icon(Icons.photo_outlined, size: size),
          )
        : Icon(Icons.photo_outlined, size: size);
  }

  static showImagePreviewDialog(String? url) {
    if (!StringHelper.isEmptyString(url)) {
      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ImagePreviewDialog(
            imageUrl: url??"",
          );
        },
      );
    }
  }
}
