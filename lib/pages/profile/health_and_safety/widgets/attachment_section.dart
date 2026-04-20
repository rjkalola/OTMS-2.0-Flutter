import 'dart:ffi';

import 'package:belcka/pages/profile/health_and_safety/widgets/file_item_tile.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AttachmentSection extends StatelessWidget {
  final bool isMandatoryField;
  final List<PlatformFile> attachmentList;
  final Function(List<PlatformFile>) onFilesSelected;
  final Function(int) onDelete;
  var deletedAttachmentIds = <String>[];

   AttachmentSection({
    super.key,
     this.isMandatoryField = false,
    required this.attachmentList,
    required this.onFilesSelected,
    required this.onDelete,
    required this.deletedAttachmentIds,
  });

  Future<void> _pickFiles() async {
    FocusManager.instance.primaryFocus?.unfocus();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp4', 'mp3', 'pdf'],
    );

    if (result != null) {
      // Correctly adding to the observed list in the controller
      attachmentList.addAll(result.files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (!isMandatoryField)
        TitleTextView(text: "attachments_text".tr, fontWeight: FontWeight.w500, fontSize: 15),

        if (isMandatoryField)
          RichText(
            text: TextSpan(
              text: '${'attachments_text'.tr} ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color:primaryTextColor_(context),
              ),
              children: [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),

        const SizedBox(height: 12),

        // 1. Upload Area
        GestureDetector(
          onTap: _pickFiles,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor_(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: defaultAccentColor_(context).withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: defaultAccentColor_(context).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.cloud_upload_outlined, color: defaultAccentColor_(context), size: 28),
                ),
                const SizedBox(height: 16),
                Text(
                  "click_to_upload".tr,
                  style: TextStyle(fontWeight: FontWeight.w600, color: defaultAccentColor_(context), fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  "${'attachment_types'.tr} • ${'max'.tr} 100 MB ${'each'.tr}",
                  style: TextStyle(color: secondaryTextColor_(context), fontSize: 13),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        Obx(() {
          if (attachmentList.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${'new_files'.tr} (${attachmentList.length})",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: primaryTextColor_(context),
                      letterSpacing: 0.5
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attachmentList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => FileItemTile(
                    file: attachmentList[index],
                    onDelete: (){

                      if ((int.tryParse(attachmentList[index].identifier ?? "") ?? 0) > 0){
                        print("removed id:${attachmentList[index].identifier} ");
                        deletedAttachmentIds.add(attachmentList[index].identifier ?? "");
                      }

                      attachmentList.removeAt(index);
                    },
                    isSaved: ((int.tryParse(attachmentList[index].identifier ?? "") ?? 0) > 0) ? true : false,
                  ),
                ),
              ],
            );
          } else {
            // Show "No attachments" when the controller list is empty
            return  Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("no_attachments_added_yet".tr, style: TextStyle(color: primaryTextColorLight_(context))),
              ),
            );
          }
        }),

      ],
    );
  }
}