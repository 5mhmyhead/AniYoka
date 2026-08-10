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

  final textTheme = getTextTheme();

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    // background and touch splash colors
    scaffoldBackgroundColor: kcSurface,
    highlightColor: kcPrimary.withValues(alpha: 0.1),
    splashColor: kcPrimary.withValues(alpha: 0.1),
    // get widget themes
    navigationBarTheme: getAppNavigationBarTheme(colorScheme, textTheme),
    tabBarTheme: getTabBarTheme(colorScheme, textTheme),
  );
}

TextTheme getTextTheme() {
  // inter is the base text theme for the app
  final baseTextTheme = GoogleFonts.interTextTheme();

  return baseTextTheme.copyWith(
    // display values for hero text and banners
    displayLarge: GoogleFonts.nunito(
      textStyle: baseTextTheme.displayLarge,
      fontWeight: FontWeight.w800,
    ),
    displayMedium: GoogleFonts.nunito(
      textStyle: baseTextTheme.displayMedium,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: GoogleFonts.nunito(
      textStyle: baseTextTheme.displaySmall,
      fontWeight: FontWeight.w600,
    ),

    // headline values for screen titles and section headers
    headlineLarge: GoogleFonts.nunito(
      textStyle: baseTextTheme.headlineLarge,
      fontSize: 26,
      fontWeight: FontWeight.w800,
    ),
    headlineMedium: GoogleFonts.nunito(
      textStyle: baseTextTheme.headlineMedium,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.nunito(
      textStyle: baseTextTheme.headlineSmall,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),

    // title values for tab bar text
    titleLarge: GoogleFonts.nunito(
      textStyle: baseTextTheme.titleLarge,
      fontSize: 16,
      fontWeight: FontWeight.w800,
    ),
    titleMedium: GoogleFonts.nunito(
      textStyle: baseTextTheme.titleMedium,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: GoogleFonts.nunito(
      textStyle: baseTextTheme.titleSmall,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),

    // body text values
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: baseTextTheme.bodySmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),

    // label values for buttons and badges, bottom nav bar
    labelLarge: GoogleFonts.nunito(
      textStyle: baseTextTheme.labelLarge,
      fontSize: 16,
      fontWeight: FontWeight.w800,
    ),
    labelMedium: GoogleFonts.nunito(
      textStyle: baseTextTheme.labelMedium,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: GoogleFonts.nunito(
      textStyle: baseTextTheme.labelSmall,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
}

NavigationBarThemeData getAppNavigationBarTheme(ColorScheme colorScheme, TextTheme textTheme) {
  return NavigationBarThemeData(
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return IconThemeData(color: colorScheme.primary);
      }

      return IconThemeData(color: colorScheme.outline);
    }),
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

// note: splash color of tab bar defaults to the primary color in 0.1 opacity
TabBarThemeData getTabBarTheme(ColorScheme colorScheme, TextTheme textTheme) {
  return TabBarThemeData(
    labelColor: colorScheme.primary,
    unselectedLabelColor: colorScheme.outline,
    labelStyle: textTheme.titleLarge,
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