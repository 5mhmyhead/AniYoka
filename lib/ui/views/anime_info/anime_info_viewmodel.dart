import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';

class AnimeInfoViewModel extends BaseViewModel {
  final _anilistService = locator<AniListService>();

  Map<String, dynamic>? _anime;
  Map<String, dynamic>? get anime => _anime;

  bool _isDescriptionExpanded = false;
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  // color for gradient depending on dominant color of anime cover image
  Color _dominantColor = kcAccentSurfaceColor;
  Color get dominantColor => _dominantColor;

  void toggleDescription() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    rebuildUi();
  }

  Future<void> loadAnimeDetails(int id) async {
    setBusy(true);
    try {
      _anime = await _anilistService.getAnimeDetails(id);
      // extract color after data is loaded
      final coverImage = _anime?['coverImage']['extraLarge'] ?? '';
      if (coverImage.isNotEmpty) {
        await _extractDominantColor(coverImage);
      }
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }

  // helpers to extract rank and popularity from rankings list
  int? get ranked {
    final rankings = _anime?['rankings'] as List?;
    final ranked = rankings?.firstWhere(
      (r) => r['type'] == 'RATED' && r['allTime'] == true,
      orElse: () => null,
    );
    return ranked?['rank'];
  }

  int? get popularity {
    final rankings = _anime?['rankings'] as List?;
    final popular = rankings?.firstWhere(
      (r) => r['type'] == 'POPULAR' && r['allTime'] == true,
      orElse: () => null,
    );
    return popular?['rank'];
  }

  List<dynamic> get recommendations {
    final nodes = _anime?['recommendations']?['nodes'] as List? ?? [];
    return nodes
        .map((n) => n['mediaRecommendation'])
        .where((m) => m != null)
        .toList();
  }

  Future<void> _extractDominantColor(String imageUrl) async {
    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
        size: const Size(200, 300),
      );
      _dominantColor = paletteGenerator.dominantColor?.color ?? kcAccentSurfaceColor;
      rebuildUi();
    } catch (e) {
      // keep fallback color if extraction fails
    }
  }

  Color get adjustedDominantColor {
    final hsl = HSLColor.fromColor(_dominantColor);
    return hsl
        .withLightness(0.2)    
        .withSaturation((hsl.saturation * 0.8).clamp(0.0, 1.0)) 
        .toColor();
  }

  String cleanDescription(String description) {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '')   // removes all html tags
        .replaceAll('&nbsp;', ' ')            // replaces html spaces
        .replaceAll('&amp;', '&')             // replaces &amp; with &
        .replaceAll('&lt;', '<')              // replaces &lt; with 
        .replaceAll('&gt;', '>')              // replaces &gt; with >
        .trim();
  }

  void copyDescription() {
    final description = _anime?['description'] ?? '';
    Clipboard.setData(ClipboardData(text: description));
  }

  String formatDate(Map? date) {
    
    if (date == null) return 'Unknown';
    final year = date['year'];
    final month = date['month'];
    final day = date['day'];
    if (year == null) return 'Unknown';
    
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', ''
    ];
    
    final monthStr = month != null ? months[month] : '';
    final dayStr = day != null ? '$day' : '';

    return '$monthStr $dayStr, $year'.trim();
  }
}