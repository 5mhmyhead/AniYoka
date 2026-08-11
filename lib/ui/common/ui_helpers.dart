import 'package:flutter/material.dart';

const double _xsSize = 4.0;
const double _smSize = 8.0;
const double _mdSize = 16.0;
const double _lgSize = 24.0;
const double _xlSize = 48.0;

const Widget horizontalSpaceXs = SizedBox(width: _xsSize);
const Widget horizontalSpaceSm = SizedBox(width: _smSize);
const Widget horizontalSpaceMd = SizedBox(width: _mdSize);
const Widget horizontalSpaceLg = SizedBox(width: _lgSize);
const Widget horizontalSpaceXl = SizedBox(width: _xlSize);

const Widget verticalSpaceXs = SizedBox(height: _xsSize);
const Widget verticalSpaceSm = SizedBox(height: _smSize);
const Widget verticalSpaceMd = SizedBox(height: _mdSize);
const Widget verticalSpaceLg = SizedBox(height: _lgSize);
const Widget verticalSpaceXl = SizedBox(height: _xlSize);

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
