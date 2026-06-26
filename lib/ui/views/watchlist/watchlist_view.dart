import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'watchlist_viewmodel.dart';

class WatchlistView extends StackedView<WatchlistViewModel> {
  const WatchlistView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, WatchlistViewModel viewModel, Widget? child) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Watchlist', style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  WatchlistViewModel viewModelBuilder(BuildContext context,) => WatchlistViewModel();
}
