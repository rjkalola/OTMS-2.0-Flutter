import 'dart:io';
import 'package:belcka/pages/profile/health_and_safety/near_miss_reporting/controller/near_miss_reporting_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/file_item_tile.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:path/path.dart' as p;

class AttachmentSection extends StatefulWidget {
  const AttachmentSection({super.key});

  @override
  State<AttachmentSection> createState() => _AttachmentSectionState();
}

class _AttachmentSectionState extends State<AttachmentSection> {
  // REMOVE THIS: final List<PlatformFile> _files = [];
  final controller = Get.find<NearMissReportingController>();

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp4', 'mp3', 'pdf'],
    );

    if (result != null) {
      // Correctly adding to the observed list in the controller
      controller.attachmentList.addAll(result.files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextView(text: "attachments_text".tr, fontWeight: FontWeight.w500, fontSize: 15),
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
                  "Click to upload",
                  style: TextStyle(fontWeight: FontWeight.w600, color: defaultAccentColor_(context), fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  "Images, Videos, Audio, PDF • Max 100 MB each",
                  style: TextStyle(color: secondaryTextColor_(context), fontSize: 13),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 2. DISPLAY LOGIC (FIXED)
        // Wrap the entire list and the header in Obx so it reacts to controller changes
        Obx(() {
          if (controller.attachmentList.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NEW FILES (${controller.attachmentList.length})",
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
                  itemCount: controller.attachmentList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => FileItemTile(
                    file: controller.attachmentList[index],
                    onDelete: () => controller.attachmentList.removeAt(index),
                  ),
                ),
              ],
            );
          } else {
            // Show "No attachments" when the controller list is empty
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("No attachments added yet", style: TextStyle(color: Colors.black38)),
              ),
            );
          }
        }),
      ],
    );
  }
}