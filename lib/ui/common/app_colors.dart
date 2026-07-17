import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kcBackgroundColor = Color(0xFF0F0F0F);
const Color kcSurfaceColor = Color(0xFF1A1A1A);
const Color kcLightGrey = Color(0xFF7F7F7F);
const Color kcOffWhite = Color(0xFFFBF5EB);

class ThemeService extends ChangeNotifier {
  ThemeService._internal();
  static final ThemeService instance = ThemeService._internal();

  static const Color _defaultAccent = Color(0xFFF45C82);

  Color _accentColor = _defaultAccent;
  Color get accentColor => _accentColor;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('accentColor');
    if (saved != null) {
      _accentColor = Color(saved);
      notifyListeners();
    }
  }

  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accentColor', color.toARGB32());
  }

  Future<void> resetToDefault() async {
    await setAccentColor(_defaultAccent);
  }

  Color get primaryPink => _accentColor;

  Color get secondaryPink {
    if (_accentColor.toARGB32() == _defaultAccent.toARGB32()) {
      return const Color(0xFFFFB7CB);
    }
    return _adjustHsl(_accentColor, sMod: 0.14, lMod: 0.20);
  }

  Color get tertiaryPink {
    if (_accentColor.toARGB32() == _defaultAccent.toARGB32()) {
      return const Color(0xFFFBD8DF);
    }
    return _adjustHsl(_accentColor, sMod: 0.10, lMod: 0.27);
  }

  Color get darkPink {
    if (_accentColor.toARGB32() == _defaultAccent.toARGB32()) {
      return const Color(0xFF171316);
    }
    return _adjustHsl(_accentColor, sMod: -0.70, lMod: -0.58);
  }

  Color get accentPink {
    if (_accentColor.toARGB32() == _defaultAccent.toARGB32()) {
      return const Color(0xFF663A4B);
    }
    return _adjustHsl(_accentColor, sMod: -0.61, lMod: -0.38);
  }

  Color get accentShadePink =>
      _adjustHsl(_accentColor, sMod: -0.50, lMod: -0.50);
  Color get accentSurfaceColor =>
      _adjustHsl(_accentColor, sMod: -0.60, lMod: -0.45);
  Color get secondaryShadePink =>
      _adjustHsl(_accentColor, sMod: 0.05, lMod: 0.08);

  Color _adjustHsl(Color color, {double sMod = 0.0, double lMod = 0.0}) {
    final hsl = HSLColor.fromColor(color);
    final saturation = (hsl.saturation + sMod).clamp(0.0, 1.0);
    final lightness = (hsl.lightness + lMod).clamp(0.0, 1.0);
    return hsl.withSaturation(saturation).withLightness(lightness).toColor();
  }
}

// Global mappings remain intact
Color get kcPrimaryPink => ThemeService.instance.primaryPink;
Color get kcSecondaryPink => ThemeService.instance.secondaryPink;
Color get kcTertiaryPink => ThemeService.instance.tertiaryPink;
Color get kcDarkPink => ThemeService.instance.darkPink;
Color get kcAccentPink => ThemeService.instance.accentPink;
Color get kcAccentShadePink => ThemeService.instance.accentShadePink;
Color get kcAccentSurfaceColor => ThemeService.instance.accentSurfaceColor;
Color get kcSecondaryShadePink => ThemeService.instance.secondaryShadePink;
