import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;

  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        children: <Widget>[
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlay) {
                  videoPlayerController.pause();
                  setState(() {
                    isPlay = false;
                  });
                } else {
                  videoPlayerController.play();
                  setState(() {
                    isPlay = true;
                  });
                }
              },
              icon: Icon(
                isPlay ? Icons.pause_circle : Icons.play_arrow,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
