import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meengle/provider/navigator_provider.dart';
import 'package:meengle/utils/sound_paths.dart';
import 'package:meengle/utils/spacer.dart';
import 'package:meengle/widgets/icon_bg.dart';
import 'package:provider/provider.dart';
import '../../utils/asset_paths.dart';
import '../../utils/colors.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final textC = TextEditingController();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Function to play the .wav sound
  void _playRingtone() async {
    await _audioPlayer
        .play(AssetSource(SoundPaths.notification)); // Play the .wav sound
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<NavigatorProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // state.setPage(AppPage.videoChat);
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).iconTheme.color,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AssetPaths.emoji,
                        height: 18,
                        width: 18,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: textC,
                      decoration: InputDecoration(
                        hintText: "Type something...",
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 2),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // state.setPage(AppPage.videoChat);
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .iconTheme
                            .color, // Dynamic background color
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AssetPaths.image,
                        height: 20,
                        width: 20,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _playRingtone();
                      // state.setPage(AppPage.videoChat);
                    },
                    icon: const IconBg(
                      assetPath: AssetPaths.send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
