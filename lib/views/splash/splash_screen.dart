import 'package:flutter/material.dart';
import 'package:meengle/provider/dashboard_provider.dart';
import 'package:meengle/provider/shared_pref_provider.dart';
import 'package:meengle/provider/video_provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../main.dart';
import '../../utils/appurl.dart';
import '../../utils/constants.dart';
import '../../utils/print.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late DashboardProvider dashboardViewModel;
  late SharedPrefProvider sharedPrefViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboardViewModel = Provider.of<DashboardProvider>(
        navigatorKey.currentContext!,
        listen: false);
    sharedPrefViewModel = Provider.of<SharedPrefProvider>(
        navigatorKey.currentContext!,
        listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      sharedPrefViewModel.getUser().then((va) {
        mDebugPrintApi(sharedPrefViewModel.getUserModel.userId);
        webSocketChannel = WebSocketChannel.connect(
          Uri.parse(
              "${AppUrl.connect}${(sharedPrefViewModel.getUserModel.userId ?? Constants.defaultString)}"), // Update with your WebSocket server URL
        );

        webSocketChannel.stream.listen(
          (message) {
            dashboardViewModel.getAction(message);
          },
          onError: (error) {
            print('Error occurred: $error');
          },
          onDone: () {
            Provider.of<VideoProvider>(navigatorKey.currentContext!,
                    listen: false)
                .onSuddenDisconnect();
          },
          cancelOnError: true,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(child: Text("L O A D I N G")),
      ),
    );
  }
}
