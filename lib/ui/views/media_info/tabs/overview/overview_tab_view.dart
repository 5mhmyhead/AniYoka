import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/views/media_info/tabs/overview/overview_tab_viewmodel.dart';
import 'package:aniyoka/ui/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  onTap: () {},
                  content: _buildSynopsis(
                    context, 
                    description: media.description ?? 'No description available.', 
                    isExpanded: viewModel.isDescriptionExpanded, 
                    onToggle: () => viewModel.toggleDescription(),
                    onCopy: () => Clipboard.setData(
                      ClipboardData(text: media.description ?? ''),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

Widget _buildStatsRow(BuildContext context, Media media) {
  final pills = <({String value, String label})>[
    if (media.nextAiringEpisode != null)
      (value: media.nextAiringEpisode!.formattedCountdown, label: 'next episode'),
    if (media.meanScore != null) 
      (value: '${media.meanScore}%', label: 'mean score'),
    if (media.episodes != null) 
      (value: '${media.episodes}', label: 'episodes'),
    if (media.popularity != null) 
      (value: media.popularity!.formatted, label: 'popularity'),
    if (media.favourites != null) 
      (value: media.favourites!.formatted, label: 'favorites'),
  ];

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

Widget _buildSynopsis(
  BuildContext context, {
  required String description,
  required bool isExpanded,
  required VoidCallback onToggle,
  required VoidCallback onCopy,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: kHorizontalPadding,
        child: Text(
          description,
          textAlign: TextAlign.justify,
          maxLines: isExpanded ? null : 5,
          overflow: isExpanded ? null : TextOverflow.ellipsis,
          style: context.textTheme.bodyMedium,
        ),
      ),
      verticalSpaceMd,
      Padding(
        padding: kHorizontalPadding,
        child: Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            Expanded(
              child: GestureDetector(
                onTap: onToggle,
                child: Icon(
                  isExpanded
                      ? Icons.arrow_circle_up_outlined
                      : Icons.arrow_circle_down_outlined,
                  color: context.colors.onSurface,
                  size: 24,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onCopy,
                  child: Icon(
                    Icons.copy,
                    color: context.colors.onSurface,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      verticalSpaceMd,
    ],
  );
}