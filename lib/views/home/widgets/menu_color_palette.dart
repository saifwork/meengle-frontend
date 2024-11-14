import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/colors.dart';

class MenuColorPalette extends StatelessWidget {
  const MenuColorPalette({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: SvgPicture.asset(
        AssetPaths.color,
        height: 25,
        width: 25,
      ),
      onSelected: (val) {
        Provider.of<ThemeProvider>(context, listen: false).changeColor(val);
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: Container(
              width: 35,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: paletteOne.color600, shape: BoxShape.circle),
            ),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Container(
              width: 35,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: asphaltPalette.color600, shape: BoxShape.circle),
            ),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: Container(
              width: 35,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: asphaltYellowPalette.color600, shape: BoxShape.circle),
            ),
          ),
          PopupMenuItem<int>(
            value: 3,
            child: Container(
              width: 35,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: asphaltRedPalette.color600, shape: BoxShape.circle),
            ),
          ),
        ];
      },
    );
  }
}
