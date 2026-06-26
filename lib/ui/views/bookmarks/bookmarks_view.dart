import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'bookmarks_viewmodel.dart';

class BookmarksView extends StackedView<BookmarksViewModel> {
  const BookmarksView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, BookmarksViewModel viewModel, Widget? child) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Bookmarks', style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  BookmarksViewModel viewModelBuilder(BuildContext context,) => BookmarksViewModel();
}
