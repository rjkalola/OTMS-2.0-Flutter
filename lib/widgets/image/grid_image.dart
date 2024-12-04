import 'dart:io';

import 'package:flutter/material.dart';

import '../../res/colors.dart';
import '../../utils/string_helper.dart';

class GridImage extends StatelessWidget {
  const GridImage({super.key, this.file, required this.onRemoveClick});

  final String? file;
  final VoidCallback onRemoveClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color of
      decoration: BoxDecoration(
        border: Border.all(
          color: rectangleBorderColor,
        ),
      ), // grid items
      child: Stack(
        fit: StackFit.expand,
        children: [
          setFile(),
          setCloseIcon(),
        ],
      ),
    );
  }

  Widget setFile() {
    return !StringHelper.isEmptyString(file) ? setImage() : setAddButton();
  }

  Widget setImage() {
    return file!.startsWith("http")
        ? Image.network(file ?? "", fit: BoxFit.cover)
        : Image.file(File(file ?? ""), fit: BoxFit.cover);
  }

  Widget setAddButton() {
    return const Center(
        child: Icon(
      Icons.add,
      size: 30,
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
                  shape: BoxShape.circle, color: Colors.white),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
