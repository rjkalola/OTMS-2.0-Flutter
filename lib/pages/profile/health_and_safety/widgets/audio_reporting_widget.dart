import 'package:flutter/material.dart';

class AudioReportingWidget extends StatefulWidget {
  const AudioReportingWidget({super.key});

  @override
  State<AudioReportingWidget> createState() => _AudioReportingWidgetState();
}

class _AudioReportingWidgetState extends State<AudioReportingWidget> {
  bool isRecording = false;
  bool hasAudio = false;
  String audioStatus = "No audio attached";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Audio Evidence",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        // --- DYNAMIC AREA ---
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: hasAudio
              ? _buildPlayerCard() // Show this if audio exists
              : (isRecording ? _buildRecordingUI() : _buildSelectionUI()), // Selection or Recording
        ),
      ],
    );
  }

  // 1. Initial State: Choose how to add audio
  Widget _buildSelectionUI() {
    return Row(
      children: [
        _actionButton(
          icon: Icons.mic_none_rounded,
          label: "Record",
          color: Colors.blue,
          onTap: () => setState(() => isRecording = true),
        ),
        const SizedBox(width: 12),
        _actionButton(
          icon: Icons.file_upload_outlined,
          label: "Upload",
          color: Colors.blueGrey,
          onTap: () {
            // Logic to pick file
            setState(() => hasAudio = true);
          },
        ),
      ],
    );
  }

  // 2. Recording State: Show Waveform placeholder & Stop button
  Widget _buildRecordingUI() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, color: Colors.red, size: 12), // Blinking dot
          const SizedBox(width: 12),
          const Expanded(
            child: Text("Recording... 0:12", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
          ),
          IconButton(
            icon: const Icon(Icons.stop_circle, color: Colors.red, size: 32),
            onPressed: () => setState(() {
              isRecording = false;
              hasAudio = true;
            }),
          )
        ],
      ),
    );
  }

  // 3. Playback State: The "File Ready" view
  Widget _buildPlayerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {}, // Play/Pause Logic
            icon: const Icon(Icons.play_arrow_rounded, color: Colors.blue, size: 30),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("voice_note_001.mp3", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                LinearProgressIndicator(value: 0.4, minHeight: 2, color: Colors.blue, backgroundColor: Colors.black12),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => hasAudio = false),
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}