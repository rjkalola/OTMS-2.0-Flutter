import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String source; // can be local path or URL

  const AudioPlayerScreen({
    super.key,
    required this.source,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLocal = false;

  @override
  void initState() {
    super.initState();
    _isLocal = _checkIfLocal(widget.source);
    _initPlayer();
  }

  bool _checkIfLocal(String path) {
    return path.startsWith('/') || path.startsWith('file://');
  }

  void _initPlayer() async {
    // listen for events
    _player.onDurationChanged.listen((d) => setState(() => _duration = d));
    _player.onPositionChanged.listen((p) => setState(() => _position = p));
    _player.onPlayerStateChanged.listen((s) {
      setState(() => _isPlaying = s == PlayerState.playing);
    });

    // set source but don’t auto play
    if (_isLocal) {
      await _player.setSourceDeviceFile(widget.source);
    } else {
      await _player.setSourceUrl(widget.source);
    }
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'audio_player'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor_(context),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.audiotrack,
                    size: 100, color: Colors.blueAccent),
                const SizedBox(height: 20),

                Text(
                  'audio_player'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                // Progress bar
                Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds
                      .clamp(0, _duration.inSeconds)
                      .toDouble(),
                  onChanged: (value) async {
                    final newPosition = Duration(seconds: value.toInt());
                    await _player.seek(newPosition);
                  },
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.grey.shade300,
                ),

                // Time indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatTime(_position)),
                    Text(_formatTime(_duration)),
                  ],
                ),

                const SizedBox(height: 30),

                // Play / Pause button
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () async {
                      if (_isPlaying) {
                        await _player.pause();
                      } else {
                        if (_isLocal) {
                          await _player.play(DeviceFileSource(widget.source));
                        } else {
                          await _player.play(UrlSource(widget.source));
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
