import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewDialog extends StatelessWidget {
  ImagePreviewDialog({super.key, required this.imageUrl});

  String imageUrl;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        // ),
        content: Stack(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: PhotoView(
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.transparent),
                    imageProvider: imageProvider(imageUrl)),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 14, 0),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        width: 28,
                        height: 28,
                        child: const Icon(
                          Icons.close,
                          size: 24,
                        )),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? imageProvider(String imageUrl) {
    if (imageUrl.startsWith("http")) {
      return NetworkImage(imageUrl);
    } else {
      return FileImage(File(imageUrl));
    }
  }
}
