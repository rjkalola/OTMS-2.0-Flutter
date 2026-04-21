import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPreviewWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbUrl;

  const VideoPreviewWidget({super.key, required this.videoUrl, required this.thumbUrl});

  @override
  State<VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<VideoPreviewWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller?.play();
      }).catchError((error) {
        debugPrint("Video Error: $error");
        _handleUnsupportedVideo();
      });
  }

  void _handleUnsupportedVideo() async {
    final Uri url = Uri.parse(widget.videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Show Video if initialized
          if (_isInitialized && _controller != null)
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            )
          // 2. Otherwise show Thumbnail
          else
            Opacity(
              opacity: 0.6,
              child: Image.network(
                widget.thumbUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
              ),
            ),

          // 3. Overlay Controls
          if (!_isInitialized)
            GestureDetector(
              onTap: _initializeVideo,
              child: const Icon(Icons.play_circle_filled, size: 64, color: Colors.white),
            )
          else if (_isInitialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(_controller!, allowScrubbing: true),
            ),

          // Loading spinner
          if (_controller != null && !_isInitialized)
            const CircularProgressIndicator(color: Colors.white),
        ],
      ),
    );
  }
}