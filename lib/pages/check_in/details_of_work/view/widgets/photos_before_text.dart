import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class PhotosBeforeText extends StatelessWidget {
  const PhotosBeforeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryTextView(
          textAlign: TextAlign.start,
          text: 'photos_before'.tr,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
