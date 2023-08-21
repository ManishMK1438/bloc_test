import 'package:bloc_test/app_widgets/loader/app_loader.dart';
import 'package:bloc_test/models/feed_model/feed_model.dart';
import 'package:bloc_test/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class FeedShortWidget extends StatefulWidget {
  final FeedModel reel;
  const FeedShortWidget({super.key, required this.reel});

  @override
  State<FeedShortWidget> createState() => _FeedShortWidgetState();
}

class _FeedShortWidgetState extends State<FeedShortWidget> {
  bool _isExpanded = false;
  late final VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.reel.video.toString()))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      })
      ..addListener(() {
        if (_controller.value.position == _controller.value.duration) {
          setState(() {
            _controller.play();
          });
        }
      });
  }

  Widget _feedInteractions() {
    return Positioned(
      left: 10,
      right: 10,
      bottom: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [_shortsDetails(), _interactionButtons()],
      ),
    );
  }

  Widget _shortsDetails() {
    return Expanded(
      flex: 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Image.network(
                widget.reel.user!.profilePic.toString(),
                errorBuilder: (q, w, e) => const FaIcon(FontAwesomeIcons.user),
              ),
            ),
            title: Text(widget.reel.user!.name.toString()),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: AnimatedContainer(
              constraints: const BoxConstraints(maxHeight: 200),
              duration: const Duration(milliseconds: 100),
              child: SingleChildScrollView(
                child: Text(
                  widget.reel.desc.toString(),
                  maxLines: _isExpanded ? null : 3,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _interactionButtons() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.heart)),
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.comment)),
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.share)),
          IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical)),
        ],
      ),
    );
  }

  Widget _progressIndicator() {
    return VideoProgressIndicator(
      _controller,
      allowScrubbing: true,
      colors: const VideoProgressColors(
          playedColor: primaryColor,
          bufferedColor: Colors.white,
          backgroundColor: Colors.white),
    );
  }

  @override
  void dispose() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: VideoPlayer(_controller),
              ),
              _feedInteractions(),
              _progressIndicator()
            ],
          )
        : const AppLoader();
  }
}
