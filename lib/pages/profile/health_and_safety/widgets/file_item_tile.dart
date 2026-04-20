import 'dart:io';
import 'package:flutter/foundation.dart'; // For Compute (background threading)
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class FileItemTile extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback onDelete;
  final bool isSaved;

  const FileItemTile({
    required this.file,
    required this.onDelete,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    String extension = p.extension(file.name).replaceAll('.', '').toUpperCase();

    String sizeText = file.size > 0
        ? '${(file.size / 1024).toStringAsFixed(0)} KB'
        : '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // File Preview Placeholder (Use Image.network if it's an image and saved)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: (isSaved && ['JPG', 'PNG', 'JPEG'].contains(extension))
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(file.path!, fit: BoxFit.cover),
            )
                : Icon(_getIcon(extension), color: Colors.black38),
          ),
          const SizedBox(width: 12),
          // File Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Badge(
                        text: extension.isEmpty ? "FILE" : extension,
                        color: Colors.blueAccent.withOpacity(0.1),
                        textColor: Colors.blueAccent
                    ),
                    if (sizeText.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(sizeText, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                    ],
                    const SizedBox(width: 8),
                    // DYNAMIC BADGE: Saved vs New
                    Badge(
                      text: isSaved ? "saved".tr : "new".tr,
                      color: isSaved ? Colors.green.withOpacity(0.1) : Color(0xFFE8F0FE),
                      textColor: isSaved ? Colors.green : Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Delete Button
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close_rounded, size: 20, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String ext) {
    if (['JPG', 'PNG', 'JPEG'].contains(ext)) return Icons.image_outlined;
    if (ext == 'PDF') return Icons.picture_as_pdf_outlined;
    if (ext == 'MP4') return Icons.video_library_outlined;
    return Icons.insert_drive_file_outlined;
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  const Badge({required this.text, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}