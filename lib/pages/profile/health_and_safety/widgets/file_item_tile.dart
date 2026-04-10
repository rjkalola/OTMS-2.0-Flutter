import 'dart:io';
import 'package:flutter/foundation.dart'; // For Compute (background threading)
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class FileItemTile extends StatefulWidget {
  final PlatformFile file;
  final VoidCallback onDelete;

  const FileItemTile({required this.file, required this.onDelete});

  @override
  State<FileItemTile> createState() => _FileItemTileState();
}

class _FileItemTileState extends State<FileItemTile> {
  String? _videoThumbnailPath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String extension = p.extension(widget.file.name).replaceAll('.', '').toUpperCase();
    String size = '${(widget.file.size / 1024).toStringAsFixed(0)} KB';
    final isImage = ['JPG', 'PNG', 'JPEG'].contains(extension);
    final isVideo = ['MP4', 'MOV'].contains(extension);
    final isPdf = extension == 'PDF';

    return Container(
      // ... same container decoration ...
      child: Row(
        children: [
          // THE DYNAMIC PREVIEW CONTAINER
          _buildPreviewContainer(context, isImage, isVideo, isPdf, extension),

          const SizedBox(width: 12),
          // ... rest of details and delete button ...
        ],
      ),
    );
  }

  // --- Building the Preview Container Logic ---
  Widget _buildPreviewContainer(BuildContext context, bool isImage, bool isVideo, bool isPdf, String ext) {
    final previewSize = 48.0;

    return Container(
      width: previewSize,
      height: previewSize,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250), // Smooth transition from placeholder to thumb
          child: _getPreviewChild(context, isImage, isVideo, isPdf, ext),
        ),
      ),
    );
  }

  // Decide what to show (Image, Video Thumb, or generic icon)
  Widget _getPreviewChild(BuildContext context, bool isImage, bool isVideo, bool isPdf, String ext) {
    // 1. Image Files (Native Flutter)
    if (isImage && widget.file.path != null) {
      return Image.file(
        File(widget.file.path!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        // Error placeholder if image can't be loaded
        errorBuilder: (ctx, _, __) => _buildGenericIcon(context, isImage, isVideo, isPdf, ext),
      );
    }

    // 2. Video Files (Generated Thumb)
    if (isVideo && _videoThumbnailPath != null) {
      return Image.file(
        File(_videoThumbnailPath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (ctx, _, __) => _buildGenericIcon(context, isImage, isVideo, isPdf, ext),
      );
    }

    // 3. PDFs and other files (Generic Icon)
    return _buildGenericIcon(context, isImage, isVideo, isPdf, ext);
  }

  Widget _buildGenericIcon(BuildContext context, bool isImage, bool isVideo, bool isPdf, String ext) {
    IconData iconData = Icons.insert_drive_file_outlined;
    if (isPdf) iconData = Icons.picture_as_pdf_outlined;
    if (isVideo) iconData = Icons.video_library_outlined;

    return Icon(iconData, color: Colors.black38);
  }
}

// --- Background Isolate for Thumbnail Generation ---
class _ThumbnailRequest {
  final String path;
  final int maxWidth;
  final int maxHeight;

  _ThumbnailRequest({required this.path, required this.maxWidth, required this.maxHeight});
}
