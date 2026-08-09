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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("ForumView")),
      ),
    );
  }

  @override
  ForumViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ForumViewModel();
}
