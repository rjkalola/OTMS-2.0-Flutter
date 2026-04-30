import 'dart:io';
import 'package:belcka/res/colors.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
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
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    print(widget.videoPath);
    _videoController = _createController();
    _initializePlayer();
  }

  VideoPlayerController _createController() {
    if (widget.isLocal) {
      return VideoPlayerController.file(File(widget.videoPath));
    }
    return VideoPlayerController.networkUrl(
      Uri.parse(widget.videoPath),
      httpHeaders: _networkVideoHeaders(),
    );
  }

  Map<String, String> _networkVideoHeaders() {
    final token = ApiConstants.accessToken;
    if (token.isEmpty) return const {};
    return {'Authorization': 'Bearer $token'};
  }

  Future<void> _initializePlayer() async {
    if (!mounted) return;
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    final controller = _videoController;
    if (controller == null) return;

    try {
      await controller.initialize();
      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: controller,
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

      setState(() {
        _isInitializing = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'video_unable_to_load'.tr;
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _retry() async {
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = _createController();
    await _initializePlayer();
  }

  Future<void> _openExternally() async {
    final uri = Uri.parse(widget.videoPath);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
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
          body: Center(child: _buildBody()),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48,
                color: secondaryExtraLightTextColor_(context)),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: secondaryExtraLightTextColor_(context)),
            ),
            const SizedBox(height: 24),
            PrimaryButton(buttonText: 'try_again'.tr,
                onPressed: _retry,
                isFixSize: true,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                width: 110,
                height: 34,),
            // if (!widget.isLocal && widget.videoPath.startsWith('http')) ...[
            //   const SizedBox(height: 12),
            //   TextButton(
            //     onPressed: _openExternally,
            //     child: Text('open_video_externally'.tr),
            //   ),
            // ],
          ],
        ),
      );
    }

    if (_isInitializing || _chewieController == null) {
      return const CircularProgressIndicator();
    }

    return Chewie(controller: _chewieController!);
  }
}
