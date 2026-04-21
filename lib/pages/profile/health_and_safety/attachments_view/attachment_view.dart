import 'package:belcka/pages/manageattachment/controller/download_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/attachments_view/audio_preview_widget.dart';
import 'package:belcka/pages/profile/health_and_safety/attachments_view/video_preview_widget.dart';
import 'package:belcka/pages/profile/health_and_safety/induction_training/model/attachment_item_model.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/custom_views/downloading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachmentSheet extends StatelessWidget {
  final List<AttachmentItemModel> attachments;
  final downloadController = Get.put(DownloadController());

  AttachmentSheet({super.key, required this.attachments}) {
    ever(downloadController.isDownloading, (bool isDownloading) {
      if (isDownloading == false && Get.isBottomSheetOpen == true) {
        Get.back();
      }
    });
  }

  static void show(BuildContext context, List<AttachmentItemModel> items) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => AttachmentSheet(attachments: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: attachments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) => _AttachmentCard(
                    item: attachments[index],
                    downloadController: downloadController,
                  ),
                ),
              ),
              _buildFooterButton(context),
            ],
          ),
        ),

        // Global Loader Overlay
        if (downloadController.isDownloading.value)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(100),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DownloadLoader(progress: downloadController.progress.value),
                ),
              ),
            ),
          ),
      ],
    ));
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.attachment_outlined, color: primaryTextColor_(context)),
              const SizedBox(width: 10),
              Text(
                "${'attachments_text'.tr} (${attachments.length})",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: primaryTextColor_(context)),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: downloadController.isDownloading.value ? null : () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: downloadController.isDownloading.value ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.blueGrey.shade100),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("close".tr, style: const TextStyle(color: Color(0xFF141D3B), fontWeight: FontWeight.w600, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final AttachmentItemModel item;
  final DownloadController downloadController;

  const _AttachmentCard({required this.item, required this.downloadController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _buildMediaView(),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.fileName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _badge(item.docType.toUpperCase(), const Color(0xFFFFF3E0), const Color(0xFFE65100)),
                          const SizedBox(width: 8),
                          _badge("saved".tr, const Color(0xFFE8F5E9), const Color(0xFF2E7D32), isBorder: true),
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.download_outlined, color: primaryTextColor_(context)),
                    onPressed: () {
                      if (!StringHelper.isEmptyString(item.imageUrl) && !downloadController.isDownloading.value) {
                        downloadController.downloadFile(
                            item.imageUrl,
                            "${item.fileName}.${item.extension}",
                            downloadSuccessMessage: 'file_downloaded'.tr
                        );
                      }
                    }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMediaView() {
    switch (item.docType) {
      case 'image':
        return InkWell(
          onTap: () => _openExternally(item.imageUrl),
          child: Image.network(
            item.imageUrl,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(Icons.broken_image, "image_not_found".tr),
          ),
        );
      case 'video':
        return VideoPreviewWidget(videoUrl: item.imageUrl, thumbUrl: item.thumbUrl);
      case 'audio':
        return AudioPreviewWidget(url: item.imageUrl);
      case 'pdf':
        return InkWell(
          onTap: () => _openExternally(item.imageUrl),
          child: Container(
            height: 180,
            color: const Color(0xFFFFEBEE),
            child: _buildPlaceholder(Icons.description, "click_to_open_pdf".tr, color: const Color(0xFFC62828)),
          ),
        );
      default:
        return InkWell(
          onTap: () => _openExternally(item.imageUrl),
          child: _buildPlaceholder(Icons.insert_drive_file, "file".tr),
        );
    }
  }

  void _openExternally(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildPlaceholder(IconData icon, String label, {Color color = Colors.grey}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _badge(String label, Color bg, Color text, {bool isBorder = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: isBorder ? Border.all(color: text, width: 0.5) : null,
      ),
      child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }
}