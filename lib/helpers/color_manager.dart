import 'dart:ui';

import 'package:flutter/material.dart';

class ColorManager {
  /// Background color for light surfaces (e.g. screens, cards, containers).
  static Color backgroundColor = const Color(0xFFFAFAFA);
  static Color backgroundColor2 = const Color(
    0xFFFBFFFB,
  ).withValues(alpha: 0.95);
  static Color mainGreen = const Color(0xFF0D9488); //main color
  // static Color mainGreen = const Color(0xFF14B8A6);
  static const Color mainBlack = Color(0xFF1E1E1E);
  static Color whiter = const Color(0xFFEBFFF8);

  /// Light neutral grey – for dividers, borders, or subtle backgrounds.
  static Color mainGrey = const Color(0xFFE0E0E0);

  static const Color appGrey = Color(0xFF616161); // same as Colors.grey[700]

  /// Medium grey – for secondary text, placeholders, or less prominent UI elements.
  static Color darkGrey = const Color(0xFF6D6D72);

  /// Disabled state color – for buttons, inputs, or icons when inactive.
  static Color disableColor = const Color(0xFFB0B0B5);

  static Color mainRed = const Color(0xFFE53935);
  static Color isRecordingColor = const Color(0xFFE74C3C);

  static Color mainBlue = const Color(0xFF2196F3);


  // static Color gradientLight = const Color(0xFF5EEAD4); // Teal-400
  // static Color gradientDark = const Color(0xFF14B8A6);  // Teal-600

  static Color gradientLightDark = const Color(0xFF2DD4BF); // Darker teal-400

}
