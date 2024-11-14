import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meengle/provider/dashboard_provider.dart';
import 'package:meengle/provider/navigator_provider.dart';
import 'package:meengle/provider/video_provider.dart';
import 'package:meengle/utils/spacer.dart';
import 'package:meengle/widgets/icon_bg.dart';
import 'package:provider/provider.dart';
import '../../utils/asset_paths.dart';

class VideoChatTab extends StatelessWidget {
  const VideoChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<NavigatorProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Provider.of<VideoProvider>(context, listen: false)
                  .toggleVideoStatus();
            },
            icon: Consumer<VideoProvider>(
              builder: (context, value, _) {
                return IconBg(
                  assetPath: value.getVideoStatus
                      ? AssetPaths.videoOff
                      : AssetPaths.videoOn,
                );
              },
            ),
          ),
          if (Provider.of<DashboardProvider>(context, listen: true)
                  .getOfferModel
                  .data !=
              null)
            IconButton(
              onPressed: () {
                Provider.of<VideoProvider>(context, listen: false)
                    .hangUpAndReconnect();
              },
              icon: const IconBg(
                assetPath: AssetPaths.call,
              ),
            ),
          IconButton(
            onPressed: () {
              Provider.of<VideoProvider>(context, listen: false)
                  .toggleMicStatus();
            },
            icon: Consumer<VideoProvider>(
              builder: (context, value, _) {
                return IconBg(
                  assetPath:
                      value.getMicStatus ? AssetPaths.micOff : AssetPaths.micOn,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
