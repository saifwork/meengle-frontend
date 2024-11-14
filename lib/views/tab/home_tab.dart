import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meengle/provider/navigator_provider.dart';
import 'package:meengle/utils/constants.dart';
import 'package:meengle/utils/spacer.dart';
import 'package:provider/provider.dart';
import '../../services/signalling.dart';
import '../../utils/asset_paths.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

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
              state.setPage(AppPage.home);
            },
            icon: const IconBg(
              title: 'Home',
              assetPath: AssetPaths.home,
            ),
          ),
          IconButton(
            onPressed: () async {
              state.setPage(AppPage.chat);
              await Signaling().openUserMedia(Constants.chat);
            },
            icon: const IconBg(
              title: 'Chat',
              assetPath: AssetPaths.chat,
            ),
          ),
          IconButton(
            onPressed: () async {
              state.setPage(AppPage.audioChat);
              await Signaling().openUserMedia(Constants.audiochat);
            },
            icon: const IconBg(
              title: 'Audio',
              assetPath: AssetPaths.micOn,
            ),
          ),
          IconButton(
            onPressed: () async {
              state.setPage(AppPage.videoChat);
              await Signaling().openUserMedia(Constants.videochat);
            },
            icon: const IconBg(
              title: 'Video',
              assetPath: AssetPaths.videoOn,
            ),
          ),
        ],
      ),
    );
  }
}

class IconBg extends StatelessWidget {
  final String title;
  final String assetPath;

  const IconBg({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Theme.of(context).iconTheme.color,
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 2,
              ),
              color: Theme.of(context).iconTheme.color,
              shape: BoxShape.circle, // Circular shape
            ),
            child: Padding(
              padding: const EdgeInsets.all(space),
              child: SvgPicture.asset(
                assetPath, // Path to the asset
                color: Theme.of(context)
                    .scaffoldBackgroundColor, // Icon color based on the theme
              ),
            ),
          ),
        ),
        MasterSpacer.h.space(2),
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
