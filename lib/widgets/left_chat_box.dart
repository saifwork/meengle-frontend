import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import '../utils/asset_paths.dart';
import '../utils/spacer.dart';

class LeftChatBox extends StatelessWidget {
  const LeftChatBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 15,
            child: SvgPicture.asset(
              AssetPaths.user,
              height: 20,
              width: 20,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          MasterSpacer.w.ten(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: padding * 2.5),
              padding: const EdgeInsets.all(space * 1.5),
              decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context)
                    .selectedPalette
                    .color800,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(padding),
                  topRight: Radius.circular(padding),
                  bottomRight: Radius.circular(padding),
                ),
              ),
              child: Text(
                "Hii, How are you Reloaded 1 of 1196 libraries in 851ms (compile: 51 ms, reload: 285 ms, reassemble: 130 ms)",
                style: TextStyle(
                    color: Provider.of<ThemeProvider>(context)
                        .selectedPalette
                        .color100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
