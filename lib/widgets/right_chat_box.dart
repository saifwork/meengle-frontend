import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import '../utils/asset_paths.dart';
import '../utils/colors.dart';
import '../utils/spacer.dart';

class RightChatBox extends StatelessWidget {
  const RightChatBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: padding),
      child: Container(
        margin: const EdgeInsets.only(left: padding * 2.5),
        padding: const EdgeInsets.all(space * 1.5),
        decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context).selectedPalette.color950,
          borderRadius: const  BorderRadius.only(
            topLeft: Radius.circular(padding),
            topRight: Radius.circular(padding),
            bottomLeft: Radius.circular(padding),
          ),
        ),
        child: Text(
          "I am fine, How about you buddy ...",
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).selectedPalette.color100,
          ),
        ),
      ),
    );
  }
}
