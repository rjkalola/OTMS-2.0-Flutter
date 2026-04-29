import 'package:belcka/pages/profile/health_and_safety/widgets/file_item_tile.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart'; // Add this
import 'package:get/get.dart';
import 'dart:io';

class AttachmentSection extends StatelessWidget {
  final bool isMandatoryField;
  final List<PlatformFile> attachmentList;
  final Function(List<PlatformFile>) onFilesSelected;
  final Function(int) onDelete;
  final List<String> deletedAttachmentIds;

  AttachmentSection({
    super.key,
    this.isMandatoryField = false,
    required this.attachmentList,
    required this.onFilesSelected,
    required this.onDelete,
    required this.deletedAttachmentIds,
  });

  // --- Picker Selection Menu ---
  void _showPickerOptions(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "select_from".tr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: Text("photos".tr),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.orange),
              title: Text("files".tr),
              onTap: () {
                Navigator.pop(context);
                _pickFiles();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp4', 'mp3', 'pdf'],
    );

    if (result != null) {
      onFilesSelected(result.files);
    }
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      List<PlatformFile> platformFiles = images.map((xFile) {
        final file = File(xFile.path);
        return PlatformFile(
          name: xFile.name,
          path: xFile.path,
          size: file.lengthSync(),
          bytes: file.readAsBytesSync(),
        );
      }).toList();

      onFilesSelected(platformFiles);
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
                color: primaryTextColor_(context),
              ),
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: () => _showPickerOptions(context),
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
                    onDelete: () {
                      final id = attachmentList[index].identifier;
                      if ((int.tryParse(id ?? "") ?? 0) > 0) {
                        deletedAttachmentIds.add(id!);
                      }
                      attachmentList.removeAt(index);
                      onDelete(index);
                    },
                    isSaved: ((int.tryParse(attachmentList[index].identifier ?? "") ?? 0) > 0),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("no_attachments_added_yet".tr, style: TextStyle(color: primaryTextColorLight_(context))),
              ),
            );
          }
        }),
      ],
    );
  }
}