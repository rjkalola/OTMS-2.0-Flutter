import 'package:belcka/pages/manage_forms/form_details/model/form_entry_file.dart';
import 'package:belcka/pages/profile/health_and_safety/attachments_view/video_preview_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FormEntryAttachmentTile extends StatelessWidget {
  const FormEntryAttachmentTile({
    super.key,
    required this.file,
    this.compactImage = false,
  });

  final FormEntryFile file;
  final bool compactImage;

  String get _url => file.url ?? '';

  String get _fileType {
    final source = _url.isNotEmpty ? _url : file.displayName;
    return ImageUtils.getFileType(source);
  }

  Future<void> _openAttachment(BuildContext context) async {
    if (StringHelper.isEmptyString(_url)) return;
    await ImageUtils.openAttachment(context, _url, _fileType);
  }

  Future<void> _openExternally() async {
    if (StringHelper.isEmptyString(_url)) return;
    final uri = Uri.tryParse(_url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_fileType) {
      case 'image':
        return _ImageAttachmentTile(
          file: file,
          compact: compactImage,
          onTap: () => _openAttachment(context),
        );
      case 'video':
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: VideoPreviewWidget(
            videoUrl: _url,
            thumbUrl: file.thumbUrl ?? '',
          ),
        );
      case 'pdf':
        return _PdfAttachmentTile(onTap: () => _openAttachment(context));
      default:
        return _DocumentDownloadRow(
          file: file,
          onTap: _openExternally,
        );
    }
  }
}

class FormEntryImageThumbnail extends StatelessWidget {
  const FormEntryImageThumbnail({
    super.key,
    required this.file,
  });

  final FormEntryFile file;

  @override
  Widget build(BuildContext context) {
    return FormEntryAttachmentTile(
      file: file,
      compactImage: true,
    );
  }
}

class _ImageAttachmentTile extends StatelessWidget {
  const _ImageAttachmentTile({
    required this.file,
    required this.compact,
    required this.onTap,
  });

  final FormEntryFile file;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = file.previewUrl;
    final height = compact ? 110.0 : 220.0;
    final width = compact ? 110.0 : double.infinity;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: height,
          width: width,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade100,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade100,
              child: Icon(
                Icons.broken_image,
                color: secondaryExtraLightTextColor_(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PdfAttachmentTile extends StatelessWidget {
  const _PdfAttachmentTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description,
              size: 40,
              color: Color(0xFFC62828),
            ),
            const SizedBox(height: 8),
            Text(
              'click_to_open_pdf'.tr,
              style: const TextStyle(
                color: Color(0xFFC62828),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentDownloadRow extends StatelessWidget {
  const _DocumentDownloadRow({
    required this.file,
    required this.onTap,
  });

  final FormEntryFile file;
  final VoidCallback onTap;

  static const Color _fileIconColor = Color(0xFF26C6DA);

  @override
  Widget build(BuildContext context) {
    final accentColor = defaultAccentColor_(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: _fileIconColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              file.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: primaryTextColor_(context),
              ),
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: Icon(Icons.download_outlined, color: accentColor),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
