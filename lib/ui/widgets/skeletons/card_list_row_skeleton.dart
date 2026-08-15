import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardListRowSkeleton extends StatelessWidget {
  const CardListRowSkeleton({super.key});

  static const double _cardWidth = 140.0;
  static const double _cardHeight = 195.0;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.surfaceContainer,
      highlightColor: context.colors.surface,
      child: SizedBox(
        height: _cardHeight + 80.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(25.0, 0, 5.0, 0),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SizedBox(
                width: _cardWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: _cardWidth,
                      height: _cardHeight,
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.mdSize),
                      ),
                    ),
                    verticalSpaceSm,
                    Container(
                      width: double.infinity,
                      height: 18.0,
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    verticalSpaceXs,
                    Container(
                      width: 100.0,
                      height: 18.0,
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    verticalSpaceSm,
                    Container(
                      width: 50.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}