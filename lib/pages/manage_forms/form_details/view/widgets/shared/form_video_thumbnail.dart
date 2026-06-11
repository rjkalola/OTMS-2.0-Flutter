import 'dart:io';

import 'package:belcka/res/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FormVideoThumbnail extends StatefulWidget {
  const FormVideoThumbnail({
    super.key,
    required this.videoPath,
    required this.onRemove,
    this.borderRadius = 10,
  });

  final String videoPath;
  final VoidCallback onRemove;
  final double borderRadius;

  @override
  State<FormVideoThumbnail> createState() => _FormVideoThumbnailState();
}

class _FormVideoThumbnailState extends State<FormVideoThumbnail> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller
          ?..setVolume(0)
          ..pause();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = _controller?.value.isInitialized ?? false;

    return Container(
      decoration: BoxDecoration(
        color: ThemeConfig.isDarkMode
            ? const Color(0xff232323)
            : const Color(0xffdadada),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isInitialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: widget.onRemove,
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black87,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
