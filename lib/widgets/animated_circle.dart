import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import '../utils/asset_paths.dart';

class AnimatedCircles extends StatefulWidget {
  const AnimatedCircles({super.key});

  @override
  _AnimatedCirclesState createState() => _AnimatedCirclesState();
}

class _AnimatedCirclesState extends State<AnimatedCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true); // Repeats the animation with reverse effect

    // Define the tween animation from 1.0 to 1.2 (pulse effect)
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final Color = Provider.of<ThemeProvider>(context).selectedPalette;
    return Stack(
      alignment: Alignment.center,
      children: [
        buildAnimCircle(300, Color.color50),
        buildAnimCircle(280, Color.color100),
        buildAnimCircle(260, Color.color200),
        buildAnimCircle(240, Color.color300),
        buildAnimCircle(220, Color.color400),
        buildAnimCircle(200, Color.color500),
        buildAnimCircle(180, Color.color600),
        buildAnimCircle(160, Color.color700),
        buildAnimCircle(140, Color.color800),
        buildAnimCircle(120, Color.color900),
        buildAnimCircle(100, Color.color950, icon: AssetPaths.micOn),
      ],
    );
  }

  Widget buildAnimCircle(double size, Color color, {String? icon}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: size * _animation.value,
          height: size * _animation.value,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: (icon != null)
              ? Center(
                  child: SvgPicture.asset(
                    icon,
                    height: 50,
                    width: 50,
                    color: Provider.of<ThemeProvider>(context)
                        .selectedPalette
                        .color50,
                  ),
                )
              : null,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }
}
