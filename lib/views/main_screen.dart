import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:meengle/provider/dashboard_provider.dart';
import 'package:meengle/provider/navigator_provider.dart';
import 'package:meengle/views/audio/audio_screen.dart';
import 'package:meengle/views/chat/chat_screen.dart';
import 'package:meengle/views/home/home_screen.dart';
import 'package:meengle/views/tab/audio_chat_tab.dart';
import 'package:meengle/views/tab/chat_tab.dart';
import 'package:meengle/views/tab/video_chat_tab.dart';
import 'package:meengle/views/video/video_screen.dart';
import 'package:meengle/views/tab/home_tab.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/theme_provider.dart';
import '../utils/actions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Timer pingTimer;

  @override
  void initState() {
    super.initState();

    startPing();
  }

  @override
  void dispose() {
    webSocketChannel.sink.close();
    pingTimer.cancel();
    super.dispose();
  }

  void startPing() {
    pingTimer = Timer.periodic(const Duration(seconds: 50), (timer) {
      Provider.of<DashboardProvider>(navigatorKey.currentContext!,
              listen: false)
          .addAction(action: CompAction.getPingReqToJson());
      print('Ping sent');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color = Provider.of<ThemeProvider>(context).selectedPalette;

    return PopScope(
      canPop: false,
      onPopInvoked: (val) async {
        final currentPage =
            Provider.of<NavigatorProvider>(context, listen: false).currentPage;

        // If we're already on the home screen, exit the app
        if (currentPage == AppPage.home) {
          Navigator.pop(navigatorKey.currentContext!);
        } else {
          Provider.of<NavigatorProvider>(context, listen: false)
              .setPage(AppPage.home);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Main Screen
              Expanded(
                child: Stack(
                  children: [
                    // Gradient background container
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).brightness == Brightness.light
                                ? Color.color400
                                : Color.color500,
                            Theme.of(context).brightness == Brightness.light
                                ? Color.color200
                                : Color.color900,
                            // Theme.of(context).brightness == Brightness.light
                            //     ? asphalt50
                            //     : asphalt950,
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: const [
                            0.1,
                            // Start the first color at 0% (top right corner)
                            0.7,
                            // The second color starts at 40% of the gradient
                          ],
                        ),
                      ),
                    ),

                    // Blur effect container
                    // ClipRRect(
                    //   borderRadius: const BorderRadius.only(
                    //     bottomLeft: Radius.circular(20),
                    //     bottomRight: Radius.circular(20),
                    //   ),
                    //   child: Positioned.fill(
                    //     child: BackdropFilter(
                    //       filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    //       child: Container(
                    //         color: Colors.black.withOpacity(0),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // Container with rounded corners at the bottom
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Consumer<NavigatorProvider>(
                        builder: (context, state, child) {
                          // Return the appropriate page widget
                          return _getPage(state.currentPage);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Navigation
              Consumer<NavigatorProvider>(
                builder: (context, state, child) {
                  // Return the appropriate page widget
                  return _getTab(state.currentPage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to return the correct screen based on the current page
  Widget _getPage(AppPage page) {
    switch (page) {
      case AppPage.home:
        return const HomeScreen();
      case AppPage.chat:
        return const ChatScreen();
      case AppPage.audioChat:
        return const AudioScreen();
      case AppPage.videoChat:
        return const VideoScreen();
      default:
        return const HomeScreen(); // Provide a default case for better handling
    }
  }

  Widget _getTab(AppPage page) {
    switch (page) {
      case AppPage.home:
        return const HomeTab();
      case AppPage.chat:
        return const ChatTab();
      case AppPage.audioChat:
        return const AudioChatTab();
      case AppPage.videoChat:
        return const VideoChatTab();
      default:
        return const HomeScreen(); // Provide a default case for better handling
    }
  }
}
