import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meengle/provider/audio_chat_provider.dart';
import 'package:meengle/provider/chat_provider.dart';
import 'package:meengle/provider/dashboard_provider.dart';
import 'package:meengle/provider/navigator_provider.dart';
import 'package:meengle/provider/theme_provider.dart';
import 'package:meengle/provider/video_chat_provider.dart';
import 'package:meengle/provider/video_provider.dart';
import 'package:meengle/views/main_screen.dart';
import 'package:meengle/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'provider/shared_pref_provider.dart';
import 'provider/timer_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
late final WebSocketChannel webSocketChannel;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("RESUMED");
        break;
      case AppLifecycleState.inactive:
        print("INACTIVE");
        // Provider.of<VideoViewModel>(navigatorKey.currentContext!, listen: false)
        //     .onSuddenDisconnect();
        break;
      case AppLifecycleState.paused:
        print("PAUSED");
        // _closeHiveBoxes();
        break;
      case AppLifecycleState.detached:
        print("DETACHED");
        Provider.of<VideoProvider>(navigatorKey.currentContext!, listen: false)
            .onSuddenDisconnect();
        break;
      case AppLifecycleState.hidden:
        print("HIDDEN");
        break;
      default:
        print(state);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavigatorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AudioChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DashboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SharedPrefProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TimerProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: themeProvider.theme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
