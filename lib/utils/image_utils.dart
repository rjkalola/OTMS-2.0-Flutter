import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  static Widget setNetworkImage(String url, double size) {
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

  static Widget setCircularNetworkImage(
      String url, double width, double height, BoxFit fit) {
    return !StringHelper.isEmptyString(url)
        ? Container(
            width: width,
            height: height,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network(
              url,
              fit: fit,
              width: width,
              height: height,
            ),
          )
        : Icon(Icons.person_outline, size: getEmptyIconSize(width, height));
  }

  static Widget setCircularFileImage(
      String url, double width, double height, BoxFit fit) {
    return !StringHelper.isEmptyString(url)
        ? Container(
            width: width,
            height: height,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.file(
              File(url ?? ""),
              width: width,
              height: height,
              fit: fit,
            ),
          )
        : Icon(Icons.person_outline, size: getEmptyIconSize(width, height));
  }

  static Widget setAssetsImage(
      String path, double width, double height, BoxFit fit) {
    return !StringHelper.isEmptyString(path)
        ? SvgPicture.asset(
            path,
            fit: fit,
            width: width,
            height: height,
          )
        : Icon(Icons.photo_outlined, size: getEmptyIconSize(width, height));
  }

  static double getEmptyIconSize(double width, double height) {
    if (width > height) {
      return height;
    } else if (width < height) {
      return width;
    } else {
      return width;
    }
  }

  static showImagePreviewDialog(String? url) {
    if (!StringHelper.isEmptyString(url)) {
      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ImagePreviewDialog(
            imageUrl: url ?? "",
          );
        },
      );
    }
  }
}
