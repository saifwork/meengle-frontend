import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models/color_palette.dart';
import '../utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;

  ThemeProvider() {
    _currentTheme = lightTheme;
  }

  bool get isDarkMode => _currentTheme == darkTheme;

  ThemeData get theme => _currentTheme;

  List<ColorPalette> colors = [
    paletteOne,
    asphaltPalette,
    asphaltYellowPalette,
    asphaltRedPalette
  ];

  int selectedColorInd = 0;
  ColorPalette selectedPalette = paletteOne;

  void changeColor(int index) {
    selectedColorInd = index;
    selectedPalette = colors[index];

    // Update the theme with the new selectedPalette
    _currentTheme = _currentTheme.copyWith(
      primaryColor: selectedPalette.color500,
      scaffoldBackgroundColor: selectedPalette.color50,
      dividerColor: selectedPalette.color950,
      colorScheme: ColorScheme.light(
        primary: selectedPalette.color500,
        secondary: selectedPalette.color300,
        background: selectedPalette.color50,
        surface: selectedPalette.color100,
      ),
      appBarTheme: AppBarTheme(
        color: selectedPalette.color500,
      ),
      iconTheme: IconThemeData(
        color: selectedPalette.color900,
        size: 24.0,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: TextStyle(
              color: selectedPalette.color900,
              fontSize: 57,
              fontWeight: FontWeight.bold),
          displayMedium: TextStyle(
              color: selectedPalette.color900,
              fontSize: 45,
              fontWeight: FontWeight.w600),
          displaySmall: TextStyle(
              color: selectedPalette.color900,
              fontSize: 36,
              fontWeight: FontWeight.w500),
          headlineLarge: TextStyle(
              color: selectedPalette.color900,
              fontSize: 32,
              fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              color: selectedPalette.color900,
              fontSize: 28,
              fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(
              color: selectedPalette.color900,
              fontSize: 24,
              fontWeight: FontWeight.w500),
          titleLarge: TextStyle(
              color: selectedPalette.color900,
              fontSize: 22,
              fontWeight: FontWeight.w600),
          titleMedium: TextStyle(
              color: selectedPalette.color800,
              fontSize: 18,
              fontWeight: FontWeight.w500),
          titleSmall: TextStyle(
              color: selectedPalette.color800,
              fontSize: 16,
              fontWeight: FontWeight.w400),
          bodyLarge: TextStyle(color: selectedPalette.color900, fontSize: 18),
          bodyMedium: TextStyle(color: selectedPalette.color800, fontSize: 16),
          bodySmall: TextStyle(color: selectedPalette.color800, fontSize: 14),
          labelLarge: TextStyle(
              color: selectedPalette.color700,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          labelMedium: TextStyle(
              color: selectedPalette.color700,
              fontSize: 12,
              fontWeight: FontWeight.w500),
          labelSmall: TextStyle(
              color: selectedPalette.color700,
              fontSize: 10,
              fontWeight: FontWeight.w400),
        ),
      ),
    );

    notifyListeners();
  }

  void toggleTheme() {
    _currentTheme = isDarkMode ? lightTheme : darkTheme;
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: selectedPalette.color500,
      scaffoldBackgroundColor: selectedPalette.color50,
      dividerColor: selectedPalette.color950,
      colorScheme: ColorScheme.light(
        primary: selectedPalette.color500,
        secondary: selectedPalette.color300,
        background: selectedPalette.color50,
        surface: selectedPalette.color100,
      ),
      appBarTheme: AppBarTheme(
        color: selectedPalette.color500,
      ),
      iconTheme: IconThemeData(
        color: selectedPalette.color900,
        size: 24.0,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: TextStyle(
              color: selectedPalette.color900,
              fontSize: 57,
              fontWeight: FontWeight.bold),
          displayMedium: TextStyle(
              color: selectedPalette.color900,
              fontSize: 45,
              fontWeight: FontWeight.w600),
          displaySmall: TextStyle(
              color: selectedPalette.color900,
              fontSize: 36,
              fontWeight: FontWeight.w500),
          headlineLarge: TextStyle(
              color: selectedPalette.color900,
              fontSize: 32,
              fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              color: selectedPalette.color900,
              fontSize: 28,
              fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(
              color: selectedPalette.color900,
              fontSize: 24,
              fontWeight: FontWeight.w500),
          titleLarge: TextStyle(
              color: selectedPalette.color900,
              fontSize: 22,
              fontWeight: FontWeight.w600),
          titleMedium: TextStyle(
              color: selectedPalette.color800,
              fontSize: 18,
              fontWeight: FontWeight.w500),
          titleSmall: TextStyle(
              color: selectedPalette.color800,
              fontSize: 16,
              fontWeight: FontWeight.w400),
          bodyLarge: TextStyle(color: selectedPalette.color900, fontSize: 18),
          bodyMedium: TextStyle(color: selectedPalette.color800, fontSize: 16),
          bodySmall: TextStyle(color: selectedPalette.color800, fontSize: 14),
          labelLarge: TextStyle(
              color: selectedPalette.color700,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          labelMedium: TextStyle(
              color: selectedPalette.color700,
              fontSize: 12,
              fontWeight: FontWeight.w500),
          labelSmall: TextStyle(
              color: selectedPalette.color700,
              fontSize: 10,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: selectedPalette.color100,
        scaffoldBackgroundColor: selectedPalette.color950,
        dividerColor: selectedPalette.color100,
        colorScheme: ColorScheme.dark(
          primary: selectedPalette.color100,
          secondary: selectedPalette.color300,
          background: selectedPalette.color900,
          surface: selectedPalette.color800,
        ),
        appBarTheme: AppBarTheme(
          color: selectedPalette.color700,
        ),
        iconTheme: IconThemeData(
          color: selectedPalette.color50,
          size: 24.0,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          TextTheme(
            displayLarge: TextStyle(
                color: selectedPalette.color50,
                fontSize: 57,
                fontWeight: FontWeight.bold),
            displayMedium: TextStyle(
                color: selectedPalette.color50,
                fontSize: 45,
                fontWeight: FontWeight.w600),
            displaySmall: TextStyle(
                color: selectedPalette.color50,
                fontSize: 36,
                fontWeight: FontWeight.w500),
            headlineLarge: TextStyle(
                color: selectedPalette.color100,
                fontSize: 32,
                fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(
                color: selectedPalette.color100,
                fontSize: 28,
                fontWeight: FontWeight.w600),
            headlineSmall: TextStyle(
                color: selectedPalette.color100,
                fontSize: 24,
                fontWeight: FontWeight.w500),
            titleLarge: TextStyle(
                color: selectedPalette.color100,
                fontSize: 22,
                fontWeight: FontWeight.w600),
            titleMedium: TextStyle(
                color: selectedPalette.color100,
                fontSize: 18,
                fontWeight: FontWeight.w500),
            titleSmall: TextStyle(
                color: selectedPalette.color100,
                fontSize: 16,
                fontWeight: FontWeight.w400),
            bodyLarge: TextStyle(color: selectedPalette.color50, fontSize: 18),
            bodyMedium:
                TextStyle(color: selectedPalette.color100, fontSize: 16),
            bodySmall: TextStyle(color: selectedPalette.color100, fontSize: 14),
            labelLarge: TextStyle(
                color: selectedPalette.color300,
                fontSize: 14,
                fontWeight: FontWeight.w600),
            labelMedium: TextStyle(
                color: selectedPalette.color300,
                fontSize: 12,
                fontWeight: FontWeight.w500),
            labelSmall: TextStyle(
                color: selectedPalette.color300,
                fontSize: 10,
                fontWeight: FontWeight.w400),
          ),
        ));
  }
}
