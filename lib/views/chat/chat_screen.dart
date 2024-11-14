import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meengle/utils/asset_paths.dart';
import 'package:meengle/widgets/left_chat_box.dart';
import 'package:provider/provider.dart';
import '../../provider/navigator_provider.dart';
import '../../utils/spacer.dart';
import '../../widgets/right_chat_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<NavigatorProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: space),
      child: Column(
        children: [
          MasterSpacer.h.space(20),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  state.setPage(AppPage.home);
                },
                icon: SvgPicture.asset(
                  AssetPaths.backward,
                  height: 30,
                  width: 30,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              MasterSpacer.w.space(5),
              CircleAvatar(
                radius: 25,
                child: SvgPicture.asset(
                  AssetPaths.user,
                  height: 30,
                  width: 30,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              MasterSpacer.w.space(15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stranger ...",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    "Online",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
          MasterSpacer.h.five(),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
          ),
          MasterSpacer.h.ten(),
          SingleChildScrollView(
            child: Column(
              children: [
                const LeftChatBox(),
                const RightChatBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
