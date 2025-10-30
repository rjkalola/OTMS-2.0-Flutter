import 'package:flutter/material.dart';


// class VideoPlayerScreen extends StatefulWidget {
//   final String source; // Can be a URL or a local file path
//   const VideoPlayerScreen({super.key, required this.source});
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late final Player _player;
//   late final VideoController _controller;
//
//   bool _isPlaying = false;
//   double _position = 0.0;
//   double _duration = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _player = Player();
//     _controller = VideoController(_player);
//
//     _player.open(Media(widget.source));
//
//     _player.streams.position.listen((pos) async {
//       final total = await _player.state.duration;
//       if (total.inMilliseconds > 0) {
//         setState(() {
//           _position = pos.inMilliseconds.toDouble();
//           _duration = total.inMilliseconds.toDouble();
//         });
//       }
//     });
//
//     _player.streams.playing.listen((playing) {
//       setState(() => _isPlaying = playing);
//     });
//   }
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
//
//   void _togglePlayPause() {
//     if (_isPlaying) {
//       _player.pause();
//     } else {
//       _player.play();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Video Player')),
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Video Display
//             Expanded(
//               child: Center(
//                 child: AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: Video(controller: _controller),
//                 ),
//               ),
//             ),
//
//             // Progress Bar
//             Slider(
//               activeColor: Colors.blueAccent,
//               inactiveColor: Colors.white24,
//               min: 0,
//               max: _duration,
//               value: _position.clamp(0, _duration),
//               onChanged: (value) {
//                 _player.seek(Duration(milliseconds: value.toInt()));
//               },
//             ),
//
//             // Controls
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
//                       color: Colors.white,
//                       size: 36),
//                   onPressed: _togglePlayPause,
//                 ),
//                 const SizedBox(width: 16),
//                 IconButton(
//                   icon: const Icon(Icons.stop, color: Colors.white, size: 32),
//                   onPressed: () => _player.stop(),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }
// }
