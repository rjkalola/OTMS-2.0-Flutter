import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/report_file_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IncidentReportCard extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String incidentType;
  final String threatLevel;
  final String date;
  final List<ReportFileInfo> files;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onAttachmentTap;

  const IncidentReportCard({
    Key? key,
    required this.imageUrl,
    required this.userName,
    required this.incidentType,
    required this.threatLevel,
    required this.date,
    required this.files,
    required this.onEdit,
    required this.onDelete,
    this.onAttachmentTap,
  }) : super(key: key);

  // Helper to get threat level colors matching your screenshot
  Color _getThreatColor() {
    switch (threatLevel.toLowerCase()) {
      case 'high':
        return Colors.red; // Soft red
      case 'medium':
        return Colors.orange; // Soft orange/amber
      case 'low':
        return  Colors.green; // Soft green
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasAttachment = files.isNotEmpty;

    return CardViewDashboardItem(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. User Profile
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: imageUrl.isNotEmpty ? CachedNetworkImageProvider(imageUrl) : null,
                  child: imageUrl.isEmpty ? Text(userName[0]) : null,
                ),
                const SizedBox(width: 12),

                // 2. Incident Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextView(text: userName, fontWeight: FontWeight.w600, fontSize: 14),
                      const SizedBox(height: 2),
                      SubtitleTextView(text: incidentType, fontSize: 13, fontWeight: FontWeight.w500),
                    ],
                  ),
                ),

                // 3. Threat Level Badge (Mobile optimized)
                if (threatLevel.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getThreatColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      threatLevel,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 4),

            // 4. Bottom Actions & Date
            Row(
              children: [
                // Date Display
                Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 11)),

                const Spacer(),

                // Attachment Action
                if (hasAttachment)
                  InkWell(
                    onTap: onAttachmentTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.attachment_rounded, color: defaultAccentColor_(context), size: 18),
                          const SizedBox(width: 2),
                          Text("${files.length}", style: TextStyle(color: defaultAccentColor_(context), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(width: 4),

                // Edit/Delete Buttons
                _buildSmallAction(Icons.edit_outlined, defaultAccentColor_(context), onEdit),
                const SizedBox(width: 4),
                _buildSmallAction(Icons.delete_outline_rounded, Colors.red.shade400, onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, color: color, size: 19),
      ),
    );
  }
}