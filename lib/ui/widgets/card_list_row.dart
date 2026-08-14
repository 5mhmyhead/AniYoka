import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/widgets/custom_tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardListRow extends StatelessWidget {
  final List<Media> listItems;

  const CardListRow({super.key, required this.listItems});

  static const double _cardWidth = 140.0;
  static const double _cardHeight = 195.0;

  @override
  Widget build(BuildContext context) {
    if (listItems.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // padding is set to 25.0 left and 5.0 right because the list item
      // has a padding right of 20.0, so we remove 20.0 padding from the right
      padding: EdgeInsets.fromLTRB(25.0, 0, 5.0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                // TODO: add anime info view here
              },
              onLongPress: () {
                // TODO: open anime info bottom sheet here 
              },
              child: SizedBox(
                width: _cardWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.mdSize),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.coverImage,
                            width: _cardWidth,
                            height: _cardHeight,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: context.colors.surfaceContainer,
                              highlightColor: context.colors.surface,
                              child: Container(
                                width: _cardWidth,
                                height: _cardHeight,
                                color: context.colors.surface,
                              )
                            ),
                            // TODO: error widget
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                // make sure to add the ontap functions here too
                                onTap: () {},
                                onLongPress: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceSm,
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                        height: 1.25,
                      ),
                    ),
                    verticalSpaceSm,
                    Row(
                      children: [
                        CustomTag(label: Text(item.format)),
                        horizontalSpaceSm,
                        if(item.rating != null)
                          CustomTag(
                            icon: const Icon(
                              Icons.star_rounded,
                              color: Colors.amberAccent,
                              size: 16,
                            ),
                            label: Text(item.rating.toString()),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
