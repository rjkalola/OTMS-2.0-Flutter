import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/report_file_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class NearMissCard extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String reportDescription;
  final String hazardType;
  final bool hasAttachment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final List<ReportFileInfo> files;
  final VoidCallback? onAttachmentTap;

  const NearMissCard({
    Key? key,
    required this.imageUrl,
    required this.userName,
    required this.reportDescription,
    required this.hazardType,
    this.hasAttachment = false,
    required this.onEdit,
    required this.onDelete,
    required this.files,
    required this.onAttachmentTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Slightly tighter padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile Picture with subtle border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: imageUrl.startsWith('http')
                        ? CachedNetworkImageProvider(imageUrl)
                        : null,
                    child: !imageUrl.startsWith('http')
                        ? Text(userName[0], style: const TextStyle(fontSize: 12))
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Main Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextView(
                        text: userName,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 2),
                      SubtitleTextView(
                        text: reportDescription,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        maxLine: 2,
                        color: Colors.grey[800],
                      ),
                      const SizedBox(height: 4),
                      // Hazard Badge-style Row
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orange.shade800),
                          const SizedBox(width: 4),
                          Text(
                            "${'hazard'.tr}: ",
                            style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          TitleTextView(
                            text: hazardType,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade800,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 0.4), // Subtle separation
            const SizedBox(height: 4),

            // 3. Polished Bottom Actions
            Row(
              children: [
                if (hasAttachment) ...[
                  InkWell(
                    onTap: onAttachmentTap,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        children: [
                          Icon(Icons.attachment_rounded, color: defaultAccentColor_(context), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            "${'attachments'.tr} (${files.length})",
                            style: TextStyle(
                              color: defaultAccentColor_(context),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const Spacer(),

                // Unified Action Buttons with tight spacing
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  color: defaultAccentColor_(context),
                  onTap: onEdit,
                ),

                _buildActionButton(
                  icon: Icons.delete_outline_outlined,
                  color: Colors.red,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to create polished, tight-fitting buttons
  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}