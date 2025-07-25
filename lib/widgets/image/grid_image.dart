import 'dart:io';

import 'package:flutter/material.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';

import '../../res/colors.dart';
import '../../utils/string_helper.dart';

class GridImage extends StatelessWidget {
  const GridImage(
      {super.key,
      this.file,
      required this.onRemoveClick,
      this.fileRadius,
      this.isEditable});

  final String? file;
  final VoidCallback onRemoveClick;
  final double? fileRadius;
  final bool? isEditable;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color of
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
          setFile(),
          Visibility(visible: isEditable ?? false, child: setCloseIcon()),
        ],
      ),
    );
  }

  Widget setFile() {
    return !StringHelper.isEmptyString(file) ? setImage() : setAddButton();
  }

  Widget setImage() {
    return file!.startsWith("http")
        ? ImageUtils.setRectangleCornerNetworkImage(
            file ?? "", 0, 0, fileRadius ?? 8.0, BoxFit.cover)
        : ImageUtils.setRectangleCornerFileImage(
            file ?? "", 0, 0, fileRadius ?? 8.0, BoxFit.cover);
  }

  Widget setAddButton() {
    return const Center(
        child: Icon(
      Icons.add,
      size: 34,
      color: Colors.white,
    ));
  }

  Widget setCloseIcon() {
    return Visibility(
      visible: !StringHelper.isEmptyString(file),
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
}
