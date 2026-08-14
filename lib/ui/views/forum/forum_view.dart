import 'package:aniyoka/ui/widgets/empty_state_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'forum_viewmodel.dart';

class ForumView extends StackedView<ForumViewModel> {
  const ForumView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ForumViewModel viewModel,
    Widget? child,
  ) {
    return EmptyStatePlaceholder(
      title: 'Forums and Reviews Tab Coming Soon',
    );
  }

  @override
  ForumViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ForumViewModel();
}
