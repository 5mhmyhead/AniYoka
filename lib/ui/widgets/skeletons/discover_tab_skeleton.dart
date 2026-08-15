import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/widgets/skeletons/card_list_row_skeleton.dart';
import 'package:aniyoka/ui/widgets/skeletons/hero_carousel_skeleton.dart';
import 'package:aniyoka/ui/widgets/skeletons/section_header_skeleton.dart';
import 'package:flutter/material.dart';

class DiscoverTabSkeleton extends StatelessWidget {
  const DiscoverTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          verticalSpaceLg,
          _buildSection(content: const HeroCarouselSkeleton()),
          _buildSection(content: const CardListRowSkeleton()),
          _buildSection(content: const CardListRowSkeleton()),
          _buildSection(content: const HeroCarouselSkeleton()),
          _buildSection(content: const CardListRowSkeleton()),
        ],
      ),
    );
  }
}

Widget _buildSection({required Widget content}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionHeaderSkeleton(),
      verticalSpaceMd,
      content,
      verticalSpaceLg,
    ],
  );
}
