import 'package:stacked/stacked.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';

class AnimeInfoViewModel extends BaseViewModel {
  final _anilistService = locator<AniListService>();

  Map<String, dynamic>? _anime;
  Map<String, dynamic>? get anime => _anime;

  bool _isDescriptionExpanded = false;
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  void toggleDescription() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    rebuildUi();
  }

  Future<void> loadAnimeDetails(int id) async {
    setBusy(true);
    try {
      _anime = await _anilistService.getAnimeDetails(id);
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
}