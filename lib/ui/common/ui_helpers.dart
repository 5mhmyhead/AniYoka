import 'package:flutter/material.dart';

const double _xsSize = 4.0;
const double _smSize = 8.0;
const double _mdSize = 16.0;
const double _lgSize = 24.0;
const double _xlSize = 48.0;

/// equates to 4.0 pixels horizontal width
const Widget horizontalSpaceXs = SizedBox(width: _xsSize);
/// equates to 8.0 pixels horizontal width
const Widget horizontalSpaceSm = SizedBox(width: _smSize);
/// equates to 16.0 pixels horizontal width
const Widget horizontalSpaceMd = SizedBox(width: _mdSize);
/// equates to 24.0 pixels horizontal width
const Widget horizontalSpaceLg = SizedBox(width: _lgSize);
/// equates to 48.0 pixels horizontal width
const Widget horizontalSpaceXl = SizedBox(width: _xlSize);

/// equates to 4.0 pixels vertical height
const Widget verticalSpaceXs = SizedBox(height: _xsSize);
/// equates to 8.0 pixels vertical height
const Widget verticalSpaceSm = SizedBox(height: _smSize);
/// equates to 16.0 pixels vertical height
const Widget verticalSpaceMd = SizedBox(height: _mdSize);
/// equates to 24.0 pixels vertical height
const Widget verticalSpaceLg = SizedBox(height: _lgSize);
/// equates to 48.0 pixels vertical height
const Widget verticalSpaceXl = SizedBox(height: _xlSize);

abstract class AppRadius {
  /// equates to 4.0 radius
  static const double xsSize = 4.0;
  /// equates to 8.0 radius
  static const double smSize = 8.0;
  /// equates to 12.0 radius
  static const double mdSize = 12.0;
  /// equates to 16.0 radius
  static const double lgSize = 16.0;
  /// equates to 24.0 radius
  static const double xlSize = 24.0;
}

/// horizontal padding for the app is set to 25.0 horizontal
const EdgeInsets kHorizontalPadding = EdgeInsets.symmetric(horizontal: 25.0);

// note: when calling colors, use context.colors.primary
// for text styles, use context.textTheme.titleLarge
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isLandscape => MediaQuery.orientationOf(this) == Orientation.landscape;
  void unfocus() => FocusScope.of(this).unfocus();
}

// for some reason, theres no in-built flutter function to capitalize the 
// first letter of a word and turning the rest to lowercase
// used in season helper mainly to get the current season as a string
extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}