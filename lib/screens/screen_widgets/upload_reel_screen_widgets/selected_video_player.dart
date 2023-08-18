import 'dart:io';

import 'package:bloc_test/app_widgets/loader/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class SelectedVideoPlayerWidget extends StatefulWidget {
  final File video;
  const SelectedVideoPlayerWidget({super.key, required this.video});

  @override
  State<SelectedVideoPlayerWidget> createState() =>
      _SelectedVideoPlayerWidgetState();
}

class _SelectedVideoPlayerWidgetState extends State<SelectedVideoPlayerWidget> {
  late final VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        setState(() {});
      })
      ..addListener(() {
        if (_controller!.value.position == _controller!.value.duration) {
          setState(() {
            _controller!.pause();
          });
        }
        print(_controller!.value.position.inSeconds);
        print(_controller!.value.duration.inSeconds);
      });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller!.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    //aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  });
                  print(_controller!.value.isPlaying);
                },
                icon: _controller!.value.isPlaying
                    ? const FaIcon(FontAwesomeIcons.pause)
                    : const FaIcon(FontAwesomeIcons.play),
                color: Colors.white,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black45),
                ),
              )
            ],
          )
        : const ImageLoader();
  }
}
