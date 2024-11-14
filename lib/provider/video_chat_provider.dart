import 'package:flutter/material.dart';

class VideoChatProvider extends ChangeNotifier {
  bool videoViewShrink = true;
  Offset position = Offset(0, 0);
  Offset? lastShrinkPosition; // To remember the last position when shrinked

  void changeViewState(double screenWidth, double screenHeight) {
    if (videoViewShrink) {
      // Store the current position before expanding
      lastShrinkPosition = position;
    }

    videoViewShrink = !videoViewShrink;
    if (videoViewShrink && lastShrinkPosition != null) {
      // When shrinking, revert to the last shrink position
      position = lastShrinkPosition!;
    } else {
      // Adjust position to keep expanded widget within bounds
      adjustPositionForExpansion(screenWidth, screenHeight);
    }

    notifyListeners();
  }

  void setPosition(Offset newPosition) {
    position = newPosition;
    notifyListeners();
  }

  void adjustPositionForExpansion(double screenWidth, double screenHeight) {
    double width = videoViewShrink ? 130 : 300;
    double height = videoViewShrink ? 180 : 500;

    double adjustedX = position.dx;
    double adjustedY = position.dy;

    if (position.dx + width > screenWidth) {
      adjustedX = screenWidth - width - 10;
    }
    if (position.dy + height > screenHeight) {
      adjustedY = screenHeight - height - 10;
    }

    if (adjustedX != position.dx || adjustedY != position.dy) {
      setPosition(Offset(adjustedX, adjustedY));
    }
  }
}