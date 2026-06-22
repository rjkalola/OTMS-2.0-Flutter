import 'package:audioplayers/audioplayers.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class FormAudioRecordingPlayer extends StatefulWidget {
  const FormAudioRecordingPlayer({
    super.key,
    required this.filePath,
    required this.title,
    this.initialDurationSeconds = 0,
  });

  final String filePath;
  final String title;
  final int initialDurationSeconds;

  @override
  State<FormAudioRecordingPlayer> createState() =>
      _FormAudioRecordingPlayerState();
}

class _FormAudioRecordingPlayerState extends State<FormAudioRecordingPlayer> {
  late final AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    if (widget.initialDurationSeconds > 0) {
      _duration = Duration(seconds: widget.initialDurationSeconds);
    }

    _player.onDurationChanged.listen((value) {
      if (!mounted) return;
      setState(() => _duration = value);
    });
    _player.onPositionChanged.listen((value) {
      if (!mounted) return;
      setState(() => _position = value);
    });
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString();
    final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
      return;
    }
    await _player.play(DeviceFileSource(widget.filePath));
  }

  @override
  Widget build(BuildContext context) {
    final maxSeconds = _duration.inSeconds > 0 ? _duration.inSeconds : 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: titleBgColor_(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: secondaryTextColor_(context),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: dividerColor_(context).withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _togglePlayback,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: primaryTextColor_(context),
                  ),
                ),
                Text(
                  '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: primaryTextColor_(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 0,
                        elevation: 0,
                      ),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: _position.inSeconds
                          .clamp(0, maxSeconds)
                          .toDouble(),
                      max: maxSeconds.toDouble(),
                      onChanged: (value) =>
                          _player.seek(Duration(seconds: value.toInt())),
                      activeColor: primaryTextColor_(context),
                      inactiveColor: normalTextFieldBorderColor_(context),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.volume_up_outlined,
                    size: 18,
                    color: secondaryTextColor_(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
