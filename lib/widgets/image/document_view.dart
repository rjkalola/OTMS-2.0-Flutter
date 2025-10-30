import 'dart:io';

import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentView extends StatelessWidget {
  DocumentView(
      {super.key,
      this.file,
      required this.onRemoveClick,
      this.fileRadius,
      this.width,
      this.height,
      this.documentIconSize,
      this.isEditable});

  final String? file;
  final VoidCallback onRemoveClick;
  final double? fileRadius, width, height, documentIconSize;
  final bool? isEditable;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color of
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: ThemeConfig.isDarkMode ? Color(0xff232323) : Color(0xffdadada),
          borderRadius: BorderRadius.circular(fileRadius ?? 8.0)
          // border: Border.all(
          //   color: rectangleBorderColor,
          // ),
          ), // grid items
      child: Stack(
        fit: StackFit.expand,
        children: [
          setDocumentImage(),
          Visibility(
              visible: (isEditable ?? true) ? true : false,
              child: setCloseIcon(file ?? "")),
        ],
      ),
    );
  }

  Widget setAddButton() {
    return const Center(
        child: Icon(
      Icons.add,
      size: 34,
      color: Colors.white,
    ));
  }

  Widget setCloseIcon(String path) {
    return Visibility(
      visible: !StringHelper.isEmptyString(path),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              onRemoveClick();
            },
            child: Container(
              margin: const EdgeInsets.all(1),
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black87),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget setDocumentImage() {
    if (!StringHelper.isEmptyString(file)) {
      final type = ImageUtils.getFileType(file!);
      switch (type) {
        case 'image':
          return file!.startsWith("http")
              ? ImageUtils.setRectangleCornerNetworkImage(
                  file ?? "", 0, 0, fileRadius ?? 8.0, BoxFit.cover)
              : ImageUtils.setRectangleCornerFileImage(
                  file ?? "", 0, 0, fileRadius ?? 8.0, BoxFit.cover);
        case 'video':
          return Center(
            child: Icon(Icons.videocam,
                size: documentIconSize ?? 34,
                color: defaultAccentColor_(Get.context!)),
          );
        case 'audio':
          return Center(
            child: Icon(Icons.audiotrack,
                size: documentIconSize ?? 34,
                color: defaultAccentColor_(Get.context!)),
          );
        case 'document':
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.insert_drive_file,
                    size: documentIconSize ?? 50,
                    color: secondaryExtraLightTextColor_(Get.context!)),
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: PrimaryTextView(
                    text: file!.split('.').last.toUpperCase(),
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          );
        case 'pdf':
          return Center(
            child: ImageUtils.setSvgAssetsImage(
                path: Drawable.pdfIcon,
                width: 38,
                height: 38,
                color: Colors.red),
          );
        default:
          return Center(
            child: Icon(Icons.insert_drive_file,
                size: documentIconSize ?? 34,
                color: secondaryExtraLightTextColor_(Get.context!)),
          );
      }
    } else {
      return setAddButton();
    }
  }
}
