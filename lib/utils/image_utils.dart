import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/file_info.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/custom_cache_manager.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../pages/common/widgets/image_preview_dialog.dart';

class ImageUtils {
  static String defaultUserAvtarUrl =
      "https://www.pngmart.com/files/22/User-Avatar-Profile-PNG-Isolated-Transparent-Picture.png";

  static Future<File?> compressImage(File file, {int quality = 90}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = path.basenameWithoutExtension(file.path);

      var outPath = "";
      if (file.path.endsWith(".jpg") || file.path.endsWith(".jpeg")) {
        outPath = path.join(tempDir.path, '${fileName}_compressed.jpg');
      } else if (file.path.endsWith(".heic")) {
        outPath = path.join(tempDir.path, '${fileName}_compressed.jpg');
      } else if (file.path.endsWith(".png")) {
        outPath = path.join(tempDir.path, '${fileName}_compressed.png');
      }

      final compressed = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: quality,
        minWidth: 900,
        minHeight: 900,
      );

      return File(compressed!.path);
    } catch (e) {
      print('Compression failed: $e');
      return null;
    }
  }

  static Widget setUserImage(
      {required String? url,
      required double width,
      required double height,
      double? radius,
      BoxFit? fit}) {
    return !StringHelper.isEmptyString(url)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 45),
            child: CachedNetworkImage(
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              cacheManager: CustomCacheManager(),
              imageUrl: url ?? "",
              fit: fit ?? BoxFit.cover,
              width: width,
              height: height,
              placeholder: (context, url) =>
                  getEmptyUserViewContainer(width: width, height: height),
              errorWidget: (context, url, error) =>
                  getEmptyUserViewContainer(width: width, height: height),
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          )
        : getEmptyUserViewContainer(width: width, height: height);
  }

  static Widget setNetworkImage(
      {required String url,
      required double width,
      required double height,
      BoxFit? fit}) {
    return !StringHelper.isEmptyString(url)
        ? Image.network(
            url,
            fit: fit ?? BoxFit.cover,
            width: width,
            height: height,
            errorBuilder: (context, url, error) => getEmptyViewContainer(
                width: width, height: height, borderRadius: 0),
          )
        : getEmptyViewContainer(width: width, height: height, borderRadius: 0);
  }

  static Widget setFileImage(
      {required String url,
      required double width,
      required double height,
      BoxFit? fit}) {
    return !StringHelper.isEmptyString(url)
        ? Image.file(
            File(url ?? ""),
            width: width,
            height: height,
            fit: fit,
          )
        : getEmptyViewContainer(width: width, height: height, borderRadius: 0);
  }

  static Widget setCircularNetworkImage(
      {required String url,
      required double width,
      required double height,
      BoxFit? fit,
      double? borderRadius}) {
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
              errorBuilder: (context, url, error) => getEmptyViewContainer(
                  width: width, height: height, borderRadius: borderRadius),
            ),
          )
        : getEmptyViewContainer(
            width: width, height: height, borderRadius: borderRadius);
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

  static Widget setRectangleCornerCachedNetworkImage(
      {required String url,
      required double width,
      required double height,
      double? borderRadius,
      BoxFit? fit}) {
    return !StringHelper.isEmptyString(url)
        ? Container(
            width: width,
            height: height,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(borderRadius ?? 0)),
            child: CachedNetworkImage(
              height: height,
              width: width,
              fit: fit,
              imageUrl: url ?? "",
              placeholder: (context, url) => getEmptyViewContainer(
                  width: width, height: height, borderRadius: borderRadius),
              errorWidget: (context, url, error) => getEmptyViewContainer(
                  width: width, height: height, borderRadius: borderRadius),
            ),
          )
        : getEmptyViewContainer(
            width: width, height: height, borderRadius: borderRadius);
  }

  static Widget getEmptyViewContainer(
      {required double width, required double height, double? borderRadius}) {
    return Container(
      width: width,
      height: height,
      decoration: AppUtils.getGrayBorderDecoration(
          color: Colors.grey.shade50, radius: borderRadius ?? 0),
      child: Icon(
        Icons.photo_outlined,
        size: getEmptyIconSize(width, height) / 2,
        color: Colors.grey.shade300,
      ),
    );
  }

  static Widget getEmptyUserViewContainer(
      {required double width, required double height}) {
    return Icon(
      Icons.account_circle,
      size: getEmptyIconSize(width, height),
      color: Colors.grey.shade400,
    );
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

  static void preloadUserImages(List<UserInfo> list) {
    for (var info in list) {
      final cache = CustomCacheManager();
      cache.downloadFile(info.userThumbImage ?? "");
    }
  }

  static ImageProvider? imageProvider(String imageUrl) {
    if (imageUrl.startsWith("http")) {
      return NetworkImage(imageUrl);
    } else {
      return FileImage(File(imageUrl));
    }
  }

  static void moveToImagePreview(List<FilesInfo> filesList, int index) {
    var arguments = {
      AppConstants.intentKey.itemList: filesList,
      AppConstants.intentKey.index: index,
    };
    Get.toNamed(AppRoutes.imagePreviewScreen, arguments: arguments);
  }
}
