import 'dart:io';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../utils/app_utils.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final bool isLocal;

  const VideoPlayerScreen({
    super.key,
    required this.videoPath,
    required this.isLocal,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _videoController = widget.isLocal
        ? VideoPlayerController.file(File(widget.videoPath))
        : VideoPlayerController.networkUrl(Uri.parse(widget.videoPath));

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      showOptions: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: defaultAccentColor_(context),
        bufferedColor: lightGreyColor(context),
        backgroundColor: lightGreyColor(context),
        handleColor: defaultAccentColor_(context),
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
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
            title: 'video_player'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor_(context),
          ),
          body: Center(
            child: _chewieController != null
                ? Chewie(controller: _chewieController!)
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
