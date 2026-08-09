import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui_helpers.dart';
import 'app_colors.dart';

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
    surfaceContainer: kcSurfaceContainer,
    surfaceContainerLow: kcSurfaceContainerLow,
    surfaceContainerHigh: kcSurfaceContainerHigh,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.interTextTheme(),
    // background and touch splash colors
    scaffoldBackgroundColor: kcSurface,
    highlightColor: kcPrimary.withValues(alpha: 0.1),
    splashColor: kcPrimary.withValues(alpha: 0.1),
    // get widget themes
    navigationBarTheme: getAppNavigationBarTheme(context, colorScheme),
    tabBarTheme: getTabBarTheme(context, colorScheme),
  );
}

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

// note: splash color of tab bar defaults to the primary color in 0.1 opacity
TabBarThemeData getTabBarTheme(BuildContext context, ColorScheme colorScheme) {
  return TabBarThemeData(
    labelColor: colorScheme.primary,
    unselectedLabelColor: colorScheme.outline,
    labelStyle: GoogleFonts.nunito(
      fontSize: getResponsiveMediumFontSize(context),
      fontWeight: FontWeight.w800
    ),
    unselectedLabelStyle: GoogleFonts.nunito(
      fontSize: getResponsiveMediumFontSize(context),
      fontWeight: FontWeight.w600
    ),

    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 4.0, color: colorScheme.primary),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      insets: EdgeInsets.only(bottom: -2.0),
    ),
    
    dividerColor: Colors.transparent,
    splashBorderRadius: BorderRadius.circular(24.0),
  );
}