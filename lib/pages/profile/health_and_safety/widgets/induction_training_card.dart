import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class InductionTrainingCard extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String trainingTitle;
  final String description;
  final List<String> teamNames;
  final bool hasAttachment;
  final VoidCallback? onAttachmentTap;

  const InductionTrainingCard({
    Key? key,
    required this.imageUrl,
    required this.userName,
    required this.trainingTitle,
    required this.description,
    required this.teamNames,
    this.hasAttachment = false,
    this.onAttachmentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(imageUrl),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      Text(
                        trainingTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                if (hasAttachment)
                  IconButton(
                    icon: Icon(Icons.attachment_outlined, color: defaultAccentColor_(context)),
                    onPressed: onAttachmentTap,
                  ),
              ],
            ),

            const SizedBox(height: 8),

            if (description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // 5. Teams (Chips)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: teamNames.map((team) => _buildTeamChip(team)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }
}