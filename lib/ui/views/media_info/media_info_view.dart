import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/views/media_info/media_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'media_info_viewmodel.dart';

class MediaInfoView extends StackedView<MediaInfoViewModel> {
  final int mediaId;
  const MediaInfoView({super.key, required this.mediaId});

  @override
  Widget builder(BuildContext context, MediaInfoViewModel viewModel, Widget? child) {
    // TODO: replace with skeleton later
    if (viewModel.isBusy) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final media = viewModel.media;

    if (media == null) {
      return const Scaffold(
        body: Center(child: Text('Something went wrong')),
      );
    }

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverPersistentHeader(
              pinned: true,
              delegate: MediaHeaderDelegate(
                media: media,
                tabBar: const TabBar(
                  isScrollable: false,
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Details'),
                    Tab(text: 'Socials'),
                  ],
                ),
                topPadding: MediaQuery.of(context).padding.top,
                screenWidth: context.screenWidth,
                onFavoritePressed: () {},
                onSharePressed: () {},
                textTheme: context.textTheme,
              ),
            ),
          ],
          body: const TabBarView(
            children: [
              Center(child: Text('Overview Content')),
              Center(child: Text('Details Content')),
              Center(child: Text('Social Content')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  MediaInfoViewModel viewModelBuilder(BuildContext context) => MediaInfoViewModel();

  @override
  void onViewModelReady(MediaInfoViewModel viewModel) => viewModel.load(mediaId);
}