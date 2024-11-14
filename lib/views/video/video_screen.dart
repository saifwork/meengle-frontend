import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meengle/provider/video_chat_provider.dart';
import 'package:meengle/provider/video_provider.dart';
import 'package:provider/provider.dart';
import '../../provider/navigator_provider.dart';
import '../../utils/asset_paths.dart';
import '../../utils/spacer.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoProvider _videoProvider;

  @override
  void initState() {
    super.initState();
    _videoProvider = Provider.of<VideoProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width - 20;
      final screenHeight = MediaQuery.of(context).size.height - 120;

      Provider.of<VideoChatProvider>(context, listen: false).setPosition(
        Offset(
          screenWidth - (130) - 10,
          screenHeight - (180) - 10,
        ),
      );
    });
  }

  @override
  void dispose() {
    _videoProvider.forceHangUp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 20;
    final screenHeight = MediaQuery.of(context).size.height - 120;
    final state = Provider.of<NavigatorProvider>(context, listen: false);

    return Container(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              final videoChatProvider =
                  Provider.of<VideoChatProvider>(context, listen: false);
              if (!videoChatProvider.videoViewShrink) {
                videoChatProvider.changeViewState(screenWidth, screenHeight);
              }
            },
            child: Consumer<VideoProvider>(builder: (context, value, _) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(padding),
                  bottomRight: Radius.circular(padding),
                ),
                child: RTCVideoView(
                  value.remoteRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              );
            }),
          ),
          Column(
            children: [
              MasterSpacer.h.space(20),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Provider.of<VideoProvider>(context, listen: false)
                          .forceHangUp();
                      state.setPage(AppPage.home);
                    },
                    icon: SvgPicture.asset(
                      AssetPaths.backward,
                      height: 30,
                      width: 30,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    AssetPaths.lock,
                    height: 20,
                    width: 20,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  MasterSpacer.w.five(),
                  Text(
                    "End-to-end Encrypted",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
              MasterSpacer.h.five(),
            ],
          ),
          Consumer<VideoChatProvider>(
            builder: (context, videoChatProvider, child) {
              return Positioned(
                left: videoChatProvider.position.dx,
                top: videoChatProvider.position.dy,
                child: GestureDetector(
                  onTap: () => videoChatProvider.changeViewState(
                      screenWidth, screenHeight),
                  onPanUpdate: (details) {
                    videoChatProvider.setPosition(
                      Offset(
                        (videoChatProvider.position.dx + details.delta.dx)
                            .clamp(
                                0,
                                screenWidth -
                                    (videoChatProvider.videoViewShrink
                                        ? 130
                                        : 300)),
                        (videoChatProvider.position.dy + details.delta.dy)
                            .clamp(
                                0,
                                screenHeight -
                                    (videoChatProvider.videoViewShrink
                                        ? 180
                                        : 500)),
                      ),
                    );
                  },
                  onPanEnd: (details) {
                    double centerX = screenWidth / 2;
                    double centerY = screenHeight / 2;
                    double widgetWidth =
                        videoChatProvider.videoViewShrink ? 130 : 300;
                    double widgetHeight =
                        videoChatProvider.videoViewShrink ? 180 : 500;

                    Offset newOffset;
                    if (videoChatProvider.position.dx < centerX &&
                        videoChatProvider.position.dy < centerY) {
                      newOffset = const Offset(10, 10);
                    } else if (videoChatProvider.position.dx >= centerX &&
                        videoChatProvider.position.dy < centerY) {
                      newOffset = Offset(screenWidth - widgetWidth - 10, 10);
                    } else if (videoChatProvider.position.dx < centerX &&
                        videoChatProvider.position.dy >= centerY) {
                      newOffset = Offset(10, screenHeight - widgetHeight - 10);
                    } else {
                      newOffset = Offset(screenWidth - widgetWidth - 10,
                          screenHeight - widgetHeight - 10);
                    }
                    videoChatProvider.setPosition(newOffset);
                  },
                  child: Container(
                    height: videoChatProvider.videoViewShrink ? 180 : 500,
                    width: videoChatProvider.videoViewShrink ? 130 : 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(padding),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    child: Consumer<VideoProvider>(
                      builder: (context, value, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(padding),
                          child: RTCVideoView(
                            value.localRenderer,
                            mirror: true,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
