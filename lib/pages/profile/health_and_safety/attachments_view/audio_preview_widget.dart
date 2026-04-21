import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPreviewWidget extends StatefulWidget {
  final String url;
  const AudioPreviewWidget({super.key, required this.url});

  @override
  State<AudioPreviewWidget> createState() => _AudioPreviewWidgetState();
}

class _AudioPreviewWidgetState extends State<AudioPreviewWidget> {
  late AudioPlayer player;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    // Listen to states
    player.onDurationChanged.listen((d) => setState(() => duration = d));
    player.onPositionChanged.listen((p) => setState(() => position = p));
    player.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.toString().padLeft(2, '0');
    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      color: const Color(0xFFF1F0FF), // Light purple background
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Music Note Icon
          CircleAvatar(
            backgroundColor: const Color(0xFFE1DFFF),
            child: Icon(Icons.music_note, color: Colors.indigo.shade900),
          ),
          const SizedBox(height: 20),
          // Dark Player Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => isPlaying ? player.pause() : player.play(UrlSource(widget.url)),
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    ),
                    child: Slider(
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds.toDouble() > 0 ? duration.inSeconds.toDouble() : 1.0,
                      activeColor: Colors.lightBlueAccent,
                      inactiveColor: Colors.grey,
                      onChanged: (value) => player.seek(Duration(seconds: value.toInt())),
                    ),
                  ),
                ),
                Text(
                  "${_formatDuration(position)} / ${_formatDuration(duration)}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                // const SizedBox(width: 8),
                // const Icon(Icons.volume_up, color: Colors.white, size: 18),
                // const SizedBox(width: 4),
                // Small volume bar representation
                //Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}