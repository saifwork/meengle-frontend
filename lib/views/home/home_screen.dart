import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meengle/provider/dashboard_provider.dart';
import 'package:meengle/utils/spacer.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/asset_paths.dart';
import 'widgets/menu_color_palette.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MasterSpacer.h.space(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hi Stranger ...",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode),
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                  const MenuColorPalette(),
                ],
              ),
            ],
          ),
          MasterSpacer.h.ten(),
          Text(
            "would you like to chat, audio chat, video chat ... ?",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Spacer(),
          Center(
            child: Text(
              "Make New\nFriends\nFace-to-Face",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          MasterSpacer.h.space(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetPaths.male,
                width: 30.0,
                height: 30.0,
                color: Theme.of(context).iconTheme.color,
              ),
              SvgPicture.asset(
                AssetPaths.female,
                width: 30.0,
                height: 30.0,
                color: Theme.of(context).iconTheme.color,
              ),
              MasterSpacer.w.ten(),
              Consumer<DashboardProvider>(
                builder: (context, value, _) {
                  return Text(
                    "${value.getActiveUserModel.data ?? 0}",
                    style: Theme.of(context).textTheme.titleSmall,
                  );
                },
              ),
              Text(
                " Users Online",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}
