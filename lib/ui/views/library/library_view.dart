import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'library_viewmodel.dart';

class LibraryView extends StackedView<LibraryViewModel> {
  const LibraryView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LibraryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("LibraryView")),
      ),
    );
  }

  @override
  LibraryViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LibraryViewModel();
}
