import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui_helpers.dart';
import 'app_colors.dart';

// gets the main theme for the application
ThemeData getAppTheme(BuildContext context) {
  const colorScheme = ColorScheme.dark(
    // primary brand colors
    primary: kcPrimary,
    secondary: kcSecondary,
    tertiary: kcTertiary,
    // surface and outline colors
    surface: kcSurface,
    onSurface: kcOnSurface,
    outline: kcOutline,
    // surface container colors
    surfaceContainerLow: kcSurfaceContainerLow,
    surfaceContainerHigh: kcSurfaceContainerHigh,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.interTextTheme(),
    // background and touch splash colors
    scaffoldBackgroundColor: kcBackground,
    highlightColor: kcPrimary.withValues(alpha: 0.1),
    splashColor: kcPrimary.withValues(alpha: 0.1),
    navigationBarTheme: getAppNavigationBarTheme(context, colorScheme),
  );
}

// app theme for bottom navigation bar getter
NavigationBarThemeData getAppNavigationBarTheme(BuildContext context, ColorScheme colorScheme) {
  return NavigationBarThemeData(
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return IconThemeData(color: colorScheme.primary);
      }

      return IconThemeData(color: colorScheme.outline);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final double fontSize = getResponsiveTinyFontSize(context);

      if (states.contains(WidgetState.selected)) {
        return GoogleFonts.nunito(
          color: colorScheme.primary,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
        );
      }

      return GoogleFonts.nunito(
        color: colorScheme.outline,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        textStyle: TextStyle(overflow: TextOverflow.ellipsis),
      );
    }),
  );
}
