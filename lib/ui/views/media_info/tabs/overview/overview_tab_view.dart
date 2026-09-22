import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/helpers/media_classes.dart';
import 'package:aniyoka/ui/views/media_info/tabs/overview/overview_tab_viewmodel.dart';
import 'package:aniyoka/ui/widgets/card_list_row.dart';
import 'package:aniyoka/ui/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:stacked/stacked.dart';

class OverviewTab extends StatefulWidget {
  final Media media;
  const OverviewTab({super.key, required this.media});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final media = widget.media;

    return ViewModelBuilder<OverviewTabViewModel>.reactive(
        viewModelBuilder: () => OverviewTabViewModel(),
        builder: (context, viewModel, child) {
          return SafeArea(
            top: false,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                verticalSpaceLg,
                _buildStatsRow(context, media),
                verticalSpaceMd,
                _buildSection(
                  title: 'Synopsis',
                  onTap: null,
                  content: _buildSynopsis(
                    context,
                    description: parse(media.description).body?.text ??
                        'No description available.',
                    isExpanded: viewModel.isDescriptionExpanded,
                    onToggle: () => viewModel.toggleDescription(),
                    onCopy: () => Clipboard.setData(
                        ClipboardData(text: media.description ?? '')),
                  ),
                ),
                _buildSection(
                  title: 'Genres and Tags',
                  onTap: null,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGenres(context, genres: media.genres ?? []),
                      verticalSpaceMd,
                      _buildTags(
                        context,
                        tags: media.tags?.take(10).toList() ?? [],
                        showSpoilers: viewModel.showSpoilerTags,
                        onToggleSpoilers: viewModel.toggleSpoilerTags,
                      ),
                    ],
                  ),
                ),
                _buildSection(
                  title: 'Related', 
                  onTap: null,
                  content: CardListRow(
                    listItems: media.relatedMedia,
                    onTap: (id) => viewModel.onMediaTap(id),
                    onLongPress: (id) => viewModel.onMediaLongPress(id),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

List<({String value, String label})> _getStatistics(Media media) {
  final pills = <({String value, String label})>[];

  if (media.nextAiringEpisode != null) pills.add((value: media.nextAiringEpisode!.formattedCountdown,label: 'next episode'));
  if (media.meanScore != null) pills.add((value: '${media.meanScore}%', label: 'mean score'));
  if (media.episodes != null) pills.add((value: '${media.episodes}', label: 'episodes'));
  if (media.volumes != null) pills.add((value: '${media.volumes}', label: 'volumes'));
  if (media.chapters != null) pills.add((value: '${media.chapters}', label: 'chapters'));
  if (media.popularity != null) pills.add((value: media.popularity!.formatted, label: 'popularity'));
  if (media.favourites != null) pills.add((value: media.favourites!.formatted, label: 'favorites'));

  return pills;
}

Widget _buildStatsRow(BuildContext context, Media media) {
  final pills = _getStatistics(media);
  if (pills.isEmpty) return const SizedBox.shrink();

  return SizedBox(
    height: 64,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: kHorizontalPadding,
      itemCount: pills.length,
      separatorBuilder: (_, __) => horizontalSpaceSm,
      itemBuilder: (context, index) {
        final pill = pills[index];
        return _buildStatPill(
          context,
          value: pill.value,
          label: pill.label,
        );
      },
    ),
  );
}

Widget _buildStatPill(
  BuildContext context, {
  required String value,
  required String label,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainer,
      borderRadius: BorderRadius.circular(AppRadius.xlSize),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.outline,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSynopsis(
  BuildContext context, {
  required String description,
  required bool isExpanded,
  required VoidCallback onToggle,
  required VoidCallback onCopy,
}) {
  return Padding(
    padding: kHorizontalPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: Text(
            description,
            textAlign: TextAlign.justify,
            maxLines: isExpanded ? null : 5,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium,
          ),
        ),
        verticalSpaceMd,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 24),
            GestureDetector(
              onTap: onToggle,
              child: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.arrow_circle_down_outlined,
                  color: context.colors.onSurface,
                  size: 24,
                ),
              ),
            ),
            GestureDetector(
              onTap: onCopy,
              child: Icon(
                Icons.copy,
                color: context.colors.onSurface,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildGenres(
  BuildContext context, {
  required List<dynamic> genres,
}) {
  return Padding(
    padding: kHorizontalPadding,
    child: Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: genres.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHigh,
            border: Border.all(color: context.colors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            genre,
            style: context.textTheme.bodySmall,
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildTags(
  BuildContext context, {
  required List<MediaTag> tags,
  required bool showSpoilers,
  required VoidCallback onToggleSpoilers,
}) {
  final visibleTags = showSpoilers ? tags : tags.where((t) => !t.isMediaSpoiler).toList();
  final spoilerCount = tags.where((t) => t.isMediaSpoiler).length;

  return Padding(
    padding: kHorizontalPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: visibleTags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: tag.isMediaSpoiler
                    ? context.colors.surfaceContainerHigh
                    : context.colors.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tag.isMediaSpoiler) ...[
                    Icon(Icons.warning_amber_rounded,
                        color: context.colors.primary, size: 14),
                    horizontalSpaceXs,
                  ],
                  Text(
                    tag.name,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: tag.isMediaSpoiler
                          ? context.colors.primary
                          : context.colors.onSurface,
                    ),
                  ),
                  horizontalSpaceXs,
                  Text(
                    '${tag.rank}%',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.outline,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (spoilerCount > 0) ...[
          verticalSpaceLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onToggleSpoilers,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: showSpoilers
                        ? context.colors.primary
                        : context.colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.colors.primary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        showSpoilers ? Icons.visibility : Icons.visibility_off,
                        color: showSpoilers
                            ? context.colors.onSurface
                            : context.colors.primary,
                        size: 15,
                      ),
                      horizontalSpaceSm,
                      Text(
                        showSpoilers ? 'Hide spoilers' : 'Show spoilers',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: showSpoilers
                              ? context.colors.onSurface
                              : context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: (spoilerCount > 0 && !showSpoilers) ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Text(
                  '$spoilerCount spoiler tag${spoilerCount > 1 ? 's' : ''} hidden',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.outline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget _buildSection({
  required String title,
  required Widget content,
  String? subtitle,
  Color? color,
  VoidCallback? onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeader(
        title: title,
        subtitle: subtitle,
        color: color,
        onTap: onTap,
      ),
      verticalSpaceMd,
      content,
      verticalSpaceLg,
    ],
  );
}
