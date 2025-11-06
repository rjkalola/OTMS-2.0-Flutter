import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/manageattachment/view/audio_player_screen.dart';
import 'package:belcka/pages/manageattachment/view/pdf_viewer_page.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/custom_cache_manager.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/common/widgets/image_preview_dialog.dart';

class ImageUtils {
  static String defaultUserAvtarUrl =
      "https://www.pngmart.com/files/22/User-Avatar-Profile-PNG-Isolated-Transparent-Picture.png";

  // 🎨 Image file extensions
  static const List<String> imageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'heic',
    'gif',
  ];

  // 🎥 Video file extensions
  static const List<String> videoExtensions = [
    'mp4',
    'mov',
    'm4v',
  ];

  // 🎵 Audio file extensions
  static const List<String> audioExtensions = [
    'mp3',
    'wav',
    'aac',
    'm4a',
    'ogg',
    'opus'
  ];

  // 📄 Document file extensions
  static const List<String> documentExtensions = [
    'doc',
    'docx',
    'txt',
    'xls',
    'xlsx',
  ];

  // 🌍 Combined list for FilePicker
  static const List<String> allAllowedExtensions = [
    ...imageExtensions,
    ...videoExtensions,
    ...audioExtensions,
    ...documentExtensions,
    "pdf"
  ];

  static String getFileType(String pathOrUrl) {
    final ext = pathOrUrl.split('.').last.toLowerCase();
    const pdfExt = ['pdf'];

    if (imageExtensions.contains(ext)) return 'image';
    if (videoExtensions.contains(ext)) return 'video';
    if (audioExtensions.contains(ext)) return 'audio';
    if (documentExtensions.contains(ext)) return 'document';
    if (pdfExt.contains(ext)) return 'pdf';
    return 'other';
  }

  static Future<void> openAttachment(
      BuildContext context, String path, String type) async {
    if (type == 'image') {
      ImageUtils.showImagePreviewDialog(path);
    } else if (type == 'audio') {
      Get.to(() => AudioPlayerScreen(
            source: path,

          ));
    } else if (type == 'video') {
      if (path.startsWith("http")) {
        final uri = Uri.parse(path);
        if (Platform.isAndroid) {
          try {
            final intent = AndroidIntent(
              action: 'action_view',
              data: uri.toString(),
              type: 'video/*',
              flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            );
            await intent.launch();
          } catch (e) {
            await launchUrl(
              Uri.parse(path),
              mode: LaunchMode.externalApplication,
            );
          }
        } else if (Platform.isIOS) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else {
        await OpenFilex.open(path);
      }
    } else if (type == 'pdf') {
      Get.to(() => PdfViewerPage(
            url: path,
          ));
    }
    // else if (type == 'document') {
    //   final ext = path.split('.').last.toLowerCase();
    //   print("document");
    //   Get.to(() => DocumentWebView(
    //         url: path,
    //       ));
    // }
    else {
      if (path.startsWith("http")) {
        if (Platform.isAndroid) {
          final intent = AndroidIntent(
            action: 'action_view',
            data: Uri.parse(path).toString(),
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await intent.launch();
        } else if (Platform.isIOS) {
          await launchUrl(
            Uri.parse(path),
            mode: LaunchMode.externalApplication,
          );
        }
      } else {
        await OpenFilex.open(path); //
      }
    }

    /* if (type == 'video' || type == 'audio') {
      await OpenFilex.open(path); // Works if path is local or valid URL
      return;
    }

    // For documents / PDFs / Excel / Word etc.
    File fileToOpen;

    if (path.startsWith('http')) {
      // Download file to temporary directory
      final response = await http.get(Uri.parse(path));
      if (response.statusCode != 200) {
        Get.snackbar('Error', 'Failed to download file: ${response.statusCode}');
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final fileName = path.split('/').last;
      final filePath = '${tempDir.path}/$fileName';
      fileToOpen = File(filePath);
      await fileToOpen.writeAsBytes(response.bodyBytes);
    } else {
      fileToOpen = File(path);
    }

    if (!await fileToOpen.exists()) {
      Get.snackbar('Error', 'File not found');
      return;
    }

    await OpenFilex.open(fileToOpen.path);*/

    // else if (type == 'pdf') {
    //   Get.to(() => PdfViewerPage(filePath: path));
    // }
    // else if (type == 'document') {
    //   final url = path.startsWith('http')
    //       ? "https://docs.google.com/gview?embedded=true&url=$path"
    //       : path;
    //   Get.to(() => DocumentWebView(url: url) );
    // }
    /* else {
      await OpenFilex.open(path);
    }*/
  }

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
