import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/views/media_info/tabs/overview/overview_tab_viewmodel.dart';
import 'package:flutter/material.dart';
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
              children: [Text(media.description ?? 'No description available.')],
            ),
          );
        });
  }
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
      borderRadius: BorderRadius.circular(50),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        verticalSpaceXs,
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