import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────
// FIXED colors — not user-customizable
// ─────────────────────────────────────────
const Color kcBackgroundColor = Color(0xFF0F0F0F);
const Color kcSurfaceColor = Color(0xFF1A1A1A);
const Color kcLightGrey = Color(0xFF7F7F7F);
const Color kcOffWhite = Color(0xFFFBF5EB);

// ─────────────────────────────────────────
// ThemeService — holds the user's chosen accent color
// and derives every "pink" shade from it automatically.
// Call ThemeService.instance.init() once at app startup,
// and wrap MaterialApp with AnimatedBuilder listening to it
// so the whole app rebuilds when the color changes.
// ─────────────────────────────────────────
class ThemeService extends ChangeNotifier {
  ThemeService._internal();
  static final ThemeService instance = ThemeService._internal();

  static const Color _defaultAccent =
      Color(0xFFF45C82); // original kcPrimaryPink

  Color _accentColor = _defaultAccent;
  Color get accentColor => _accentColor;

  // Loads the saved accent color (if any) from disk. Call once at startup.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('accentColor');
    if (saved != null) {
      _accentColor = Color(saved);
      notifyListeners();
    }
  }

  // Call this from the "Change App Color" hex input screen.
  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accentColor', color.value);
  }

  Future<void> resetToDefault() async {
    await setAccentColor(_defaultAccent);
  }

  // ── Derived shades, generated from the single accent color ──
  // These replace the old hardcoded constants below.

  Color get primaryPink => _accentColor;

  Color get secondaryPink => _lighten(_accentColor, 0.25);

  Color get tertiaryPink => _lighten(_accentColor, 0.42);

  Color get darkPink => _darken(_accentColor, 0.85);

  Color get accentPink => _darken(_accentColor, 0.35);

  Color get accentShadePink => _darken(_accentColor, 0.78);

  Color get accentSurfaceColor => _darken(_accentColor, 0.72);

  Color get secondaryShadePink => _lighten(_accentColor, 0.12);

  // ── HSL-based lighten/darken helpers ──
  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

// ─────────────────────────────────────────
// Convenience top-level getters — kept with the SAME NAMES
// as your old constants, so most of your existing code
// (e.g. `color: kcPrimaryPink`) still works without renaming.
//
// ⚠️ IMPORTANT: these are no longer `const`. Any widget that
// wraps them in a `const` constructor (e.g. `const BoxDecoration(color: kcPrimaryPink)`)
// will now fail to compile — remove the `const` keyword in
// those specific spots. We'll fix these file by file.
// ─────────────────────────────────────────
Color get kcPrimaryPink => ThemeService.instance.primaryPink;
Color get kcSecondaryPink => ThemeService.instance.secondaryPink;
Color get kcTertiaryPink => ThemeService.instance.tertiaryPink;
Color get kcDarkPink => ThemeService.instance.darkPink;
Color get kcAccentPink => ThemeService.instance.accentPink;
Color get kcAccentShadePink => ThemeService.instance.accentShadePink;
Color get kcAccentSurfaceColor => ThemeService.instance.accentSurfaceColor;
Color get kcSecondaryShadePink => ThemeService.instance.secondaryShadePink;
