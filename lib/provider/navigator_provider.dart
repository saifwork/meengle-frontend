import 'package:flutter/material.dart';

enum AppPage { home, chat, audioChat, videoChat }

class NavigatorProvider extends ChangeNotifier {
  AppPage _currentPage = AppPage.home;

  AppPage get currentPage => _currentPage;

  void setPage(AppPage page) {
    _currentPage = page;
    notifyListeners();
  }
}
