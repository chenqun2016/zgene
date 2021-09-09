import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({
    Key key,
    this.title = 'Chewie Demo',
    this.linkUrl,
  }) : super(key: key);
  final String linkUrl;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _VideoPageState();
  }
}

class _VideoPageState extends State<VideoPage> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _platform = defaultTargetPlatform;
    if (null != widget.linkUrl && widget.linkUrl.isNotEmpty) {
      initializePlayer();
    }
    print("linkUrl==" + widget.linkUrl);
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.linkUrl);

    await _videoPlayerController1.initialize();
    _Controller();
    setState(() {});
  }

  void _Controller() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      showOptions: false,
      // customControls: MaterialControls()
      customControls: CupertinoControls(
        backgroundColor: Colors.black,
        iconColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: _chewieController != null &&
                    _chewieController.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        '加载中',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
