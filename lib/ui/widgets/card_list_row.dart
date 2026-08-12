import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/widgets/custom_tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardListRow extends StatelessWidget {
  final List<Media> listItems;

  const CardListRow({super.key, required this.listItems});

  @override
  Widget build(BuildContext context) {
    if (listItems.isEmpty) return const SizedBox.shrink(); // TODO: change to no anime found

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // padding: const EdgeInsets.symmetric(horizontal: 25.0), // TODO: magic number
      padding: const EdgeInsets.fromLTRB(25.0, 0, 5.0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(right: 20.0), // TODO: magic number
            child: GestureDetector(
              onTap: () {
                // TODO: add anime info view here
              },
              onLongPress: () {
                // TODO: open anime info bottom sheet here 
              },
              child: SizedBox(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0), // TODO: magic number
                      child: CachedNetworkImage(
                        imageUrl: item.coverImage,
                        width: 140,
                        height: 195,
                        fit: BoxFit.cover,
                        // TODO: ADD PLACEHOLDER AND ERROR WIDGET
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
                        if(item.rating != 0.0)
                          CustomTag(
                            icon: const Icon(
                              Icons.star_rounded,
                              color: Colors.amberAccent,
                              size: 16,
                            ),
                            label: Text(item.rating.toStringAsFixed(1)),
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
