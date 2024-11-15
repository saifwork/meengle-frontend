import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../provider/dashboard_provider.dart';
import '../../provider/navigator_provider.dart';
import '../../provider/timer_provider.dart';
import '../../provider/video_provider.dart';
import '../../utils/asset_paths.dart';
import '../../utils/spacer.dart';
import '../../widgets/animated_circle.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late VideoProvider _videoProvider;
  late TimerProvider _timerProvider;

  @override
  void initState() {
    super.initState();
    _videoProvider = Provider.of<VideoProvider>(context, listen: false);
    _timerProvider = Provider.of<TimerProvider>(context, listen: false);
    _timerProvider.startTimer();
  }

  @override
  void dispose() {
    _timerProvider.stopTimer(); // Stop the timer when leaving the screen
    _videoProvider.forceHangUp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigatorProvider =
        Provider.of<NavigatorProvider>(context, listen: false);

    return Consumer<DashboardProvider>(
      builder: (context, state, child) {
        return state.getOfferModel.data != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: space),
                child: Column(
                  children: [
                    MasterSpacer.h.space(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            navigatorProvider.setPage(AppPage.home);
                          },
                          icon: SvgPicture.asset(
                            AssetPaths.backward,
                            height: 30,
                            width: 30,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        Text(
                          "OnGoing Call",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                    MasterSpacer.h.five(),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      thickness: 0.5,
                    ),
                    const Expanded(child: AnimatedCircles()),
                    Text(
                      "Stranger",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    MasterSpacer.h.five(),
                    Consumer<TimerProvider>(
                      builder: (context, timerProvider, child) {
                        return Text(
                          timerProvider.formattedTime,
                          style: Theme.of(context).textTheme.labelLarge,
                        );
                      },
                    ),
                    MasterSpacer.h.ten(),
                  ],
                ),
              )
            : const Center(child: Text("W A I T I N G"));
      },
    );
  }
}
