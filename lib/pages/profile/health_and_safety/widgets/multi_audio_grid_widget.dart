import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class MultiAudioGridWidget extends StatefulWidget {
  const MultiAudioGridWidget({super.key});

  @override
  State<MultiAudioGridWidget> createState() => _MultiAudioGridWidgetState();
}

class _MultiAudioGridWidgetState extends State<MultiAudioGridWidget> {
  // Mock data list to store audio items
  // In a real app, this would be a List of objects containing file paths/durations
  final List<Map<String, String>> _audioList = [
    {"name": "Voice Note 1", "duration": "0:12", "type": "recorded"},
    {"name": "Site_Ambient.mp3", "duration": "1:05", "type": "upload"},
  ];

  void _addMockAudio(String type) {
    setState(() {
      _audioList.add({
        "name": type == "recorded" ? "New Recording ${_audioList.length + 1}" : "Uploaded_File.mp3",
        "duration": "0:30",
        "type": type
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextView(text: "${'upload'.tr} ${'record'.tr} / ${'audio'.tr}".tr,fontWeight: FontWeight.w500,),
        const SizedBox(height: 8),
        // 1. Action Buttons (Record/Upload)
        Row(
          children: [
            _buildActionButton(
              label: "record".tr,
              icon: Icons.mic_rounded,
              color: Colors.blueGrey,
              onTap: () => _addMockAudio("recorded"),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              label: 'upload'.tr,
              icon: Icons.audiotrack_rounded,
              color: Colors.blueGrey,
              onTap: () => _addMockAudio("upload"),
            ),
          ],
        ),

        const SizedBox(height: 12),
        // 2. The Audio Grid
        if (_audioList.isNotEmpty) ...[

          GridView.builder(
            shrinkWrap: true, // Important for use inside ScrollViews
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5, // Adjust this to make tiles wider/taller
            ),
            itemCount: _audioList.length,
            itemBuilder: (context, index) {
              final item = _audioList[index];
              return _buildAudioTile(item, index);

            },

          ),
          const SizedBox(height: 16), // Space between grid and next section
        ],

      ],
    );
  }

  // A single tile in the grid
  Widget _buildAudioTile(Map<String, String> item, int index) {
    bool isRecorded = item['type'] == 'recorded';

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Play Icon Container
                CircleAvatar(
                  radius: 16,
                  backgroundColor: defaultAccentColor_(context).withOpacity(0.1),
                  child: Icon(Icons.play_arrow_rounded, size: 20, color: defaultAccentColor_(context)),
                ),
                const SizedBox(width: 8),
                // Text Info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']!,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(item['duration']!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Delete Button (Top Right)
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 14, color: Colors.redAccent),
              onPressed: () => setState(() => _audioList.removeAt(index)),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}