import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/widgets/custom_tag.dart';
import 'package:aniyoka/ui/widgets/shimmer_placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardListRow extends StatelessWidget {
  final List<Media> listItems;

  final void Function(int id) onTap;
  final void Function(int id) onLongPress;

  const CardListRow({
    super.key, 
    required this.listItems,
    required this.onTap,
    required this.onLongPress,
  });

  static const double _cardWidth = 140.0;
  static const double _cardHeight = 195.0;

  @override
  Widget build(BuildContext context) {
    if (listItems.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: _cardHeight + 80.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(25.0, 0, 5.0, 0),
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          final item = listItems[index];
          return Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => onTap(item.id),
              onLongPress: () => onLongPress(item.id),
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
                            placeholder: (context, url) => const ShimmerPlaceholder(),
                            errorWidget: (context, url, error) => const ShimmerPlaceholder(),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => onTap(item.id),
                                onLongPress: () => onLongPress(item.id),
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
                        if (item.rating != null)
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
        },
      ),
    );
  }
}
