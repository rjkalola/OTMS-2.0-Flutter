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

  static Widget setNetworkImage(
      String url, double width, double height, BoxFit? fit) {
    return !StringHelper.isEmptyString(url)
        ? Image.network(
            url,
            fit: fit ?? BoxFit.cover,
            width: width,
            height: height,
            errorBuilder: (context, url, error) => Icon(
              Icons.photo_outlined,
              size: getEmptyIconSize(width, height),
              weight: 300,
            ),
          )
        : Icon(
            Icons.photo_outlined,
            size: getEmptyIconSize(width, height),
            weight: 300,
          );
  }

  static Widget setFileImage(
      String url, double width, double height, BoxFit? fit) {
    return !StringHelper.isEmptyString(url)
        ? Image.file(
            File(url ?? ""),
            width: width,
            height: height,
            fit: fit,
          )
        : Icon(
            Icons.photo_outlined,
            size: getEmptyIconSize(width, height),
            weight: 300,
          );
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
        : Icon(Icons.photo_outlined, size: getEmptyIconSize(width, height));
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
        : Icon(Icons.photo_outlined, size: getEmptyIconSize(width, height));
  }

  static Widget setRectangleCornerNetworkImage(String url, double width,
      double height, double borderRadius, BoxFit fit) {
    return !StringHelper.isEmptyString(url)
        ? Container(
            width: width,
            height: height,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(borderRadius)),
            child: Image.network(
              url,
              fit: fit,
              width: width,
              height: height,
            ),
          )
        : Icon(Icons.photo_outlined, size: getEmptyIconSize(width, height));
  }

  static Widget setRectangleCornerFileImage(String url, double width,
      double height, double borderRadius, BoxFit fit) {
    return !StringHelper.isEmptyString(url)
        ? Container(
            width: width,
            height: height,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(borderRadius)),
            child: Image.file(
              File(url ?? ""),
              width: width,
              height: height,
              fit: fit,
            ),
          )
        : Icon(Icons.photo_outlined, size: getEmptyIconSize(width, height));
  }

  static Widget setSvgAssetsImage(
      {required String path,
      required double width,
      required double height,
      BoxFit? fit,
      Color? color}) {
    return !StringHelper.isEmptyString(path)
        ? SvgPicture.asset(
            path,
            fit: fit ?? BoxFit.cover,
            width: width,
            height: height,
            colorFilter:
                color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
          )
        : Icon(Icons.photo_outlined, size: getEmptyIconSize(width, height));
  }

  static Widget setAssetsImage(
      {required String path,
      required double width,
      required double height,
      BoxFit? fit,
      Color? color}) {
    return !StringHelper.isEmptyString(path)
        ? Image.asset(
            path,
            fit: fit ?? BoxFit.contain,
            width: width,
            height: height,
            color: color,
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
