import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/spacer.dart';

class IconBg extends StatelessWidget {
  final String? title;
  final String assetPath;

  const IconBg({
    super.key,
    this.title,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color:
                Theme.of(context).iconTheme.color, // Dynamic background color
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 2,
              ),
              color:
                  Theme.of(context).iconTheme.color, // Dynamic background color
              shape: BoxShape.circle, // Circular shape
            ),
            child: Padding(
              padding: const EdgeInsets.all(space),
              child: SvgPicture.asset(
                assetPath, // Path to the asset
                color: Theme.of(context)
                    .scaffoldBackgroundColor, // Icon color based on the theme
              ),
            ),
          ),
        ),
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
      ],
    );
  }
}
