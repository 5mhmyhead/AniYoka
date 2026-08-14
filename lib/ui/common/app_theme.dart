import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final textTheme = getTextTheme(colorScheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    // background and touch splash colors
    scaffoldBackgroundColor: kcSurface,
    highlightColor: kcOnSurface.withValues(alpha: 0.1),
    splashColor: kcOnSurface.withValues(alpha: 0.1),
    // get widget themes
    navigationBarTheme: getAppNavigationBarTheme(colorScheme, textTheme),
    tabBarTheme: getTabBarTheme(colorScheme, textTheme),
  );
}

// overriding these text styles using fontWeight using ?.copyWith() 
// returns some weird material 3 display quirks so override fontSize instead
TextTheme getTextTheme(ColorScheme colorScheme) {
  return TextTheme(
    // display
    displayLarge: GoogleFonts.nunito(
      fontSize: 48,
      fontWeight: FontWeight.w900,
    ),
    displayMedium: GoogleFonts.nunito(
      fontSize: 40,
      fontWeight: FontWeight.w800,
    ),
    displaySmall: GoogleFonts.nunito(
      fontSize: 32,
      fontWeight: FontWeight.w700,
    ),

    // headline
    headlineLarge: GoogleFonts.nunito(
      fontSize: 26,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    headlineSmall: GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
    ),

    // title
    titleLarge: GoogleFonts.nunito(
      fontSize: 20,
      fontWeight: FontWeight.w800,
    ),
    titleMedium: GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),

    // body
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),

    // label
    labelLarge: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w800,
    ),
    labelMedium: GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    // label small for custom tags
    labelSmall: GoogleFonts.nunito(
      fontSize: 12,
      fontWeight: FontWeight.w800,
    ),
  ).apply(
    bodyColor: colorScheme.onSurface,
    displayColor: colorScheme.onSurface,
  );
}

NavigationBarThemeData getAppNavigationBarTheme(
    ColorScheme colorScheme, TextTheme textTheme) {
  return NavigationBarThemeData(
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed) ||
          states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused)) {
        return colorScheme.primary.withValues(alpha: 0.1);
      }
      return Colors.transparent;
    }),
    //
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return IconThemeData(color: colorScheme.primary);
      }

      return IconThemeData(color: colorScheme.outline);
    }),
    //
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w800,
          overflow: TextOverflow.ellipsis,
        );
      }

      return textTheme.labelMedium?.copyWith(
        color: colorScheme.outline,
        fontWeight: FontWeight.w600,
        overflow: TextOverflow.ellipsis,
      );
    }),
  );
}

// splash color of tab bar defaults to the primary color in 0.1 opacity
TabBarThemeData getTabBarTheme(ColorScheme colorScheme, TextTheme textTheme) {
  return TabBarThemeData(
    labelColor: colorScheme.primary,
    unselectedLabelColor: colorScheme.outline,
    // i'd want the selected label style to have a thicker font weight,
    // but the font weight only updates AFTER the tab bar animation completes
    // keep it as is for now
    labelStyle: textTheme.titleMedium,
    unselectedLabelStyle: textTheme.titleMedium,

    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 4.0, color: colorScheme.primary),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      insets: EdgeInsets.only(bottom: -2.0),
    ),

    dividerColor: Colors.transparent,
    splashBorderRadius: BorderRadius.circular(24.0),
  );
}
