import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'media_info_viewmodel.dart';

class MediaInfoView extends StackedView<MediaInfoViewModel> {
  final int mediaId;
  const MediaInfoView({super.key, required this.mediaId});

  @override
  Widget builder(BuildContext context, MediaInfoViewModel viewModel, Widget? child) {
    final media = viewModel.media;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(media?.title ?? ''),
      ),
      body: viewModel.isBusy
          ? Center(child: CircularProgressIndicator())
          : Center(child: Text(media?.title ?? '')),
    );
  }

  @override
  MediaInfoViewModel viewModelBuilder(BuildContext context) => MediaInfoViewModel();

  @override
  void onViewModelReady(MediaInfoViewModel viewModel) => viewModel.load(mediaId);
}
