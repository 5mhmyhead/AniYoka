import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/services/anilist_service.dart';
import 'package:stacked/stacked.dart';

class MediaInfoViewModel extends BaseViewModel {
  final _aniListService = locator<AniListService>();
  
  Media? _media;
  Media? get media => _media;

  Future<void> load(int id) async {
    _media = await runBusyFuture(_aniListService.fetchAnimeDetails(id));
  }
}
