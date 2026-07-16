import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeCardRow extends StatelessWidget {
  final List<dynamic> animeList;
  final void Function(int id)? onAnimeTap;

  const AnimeCardRow({
    super.key,
    required this.animeList,
    this.onAnimeTap,
  });

  @override
  Widget build(BuildContext context) {
    if (animeList.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'No anime found',
            style: TextStyle(color: kcLightGrey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
        itemCount: animeList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final anime = animeList[index];
          final title =
              anime['title']['english'] ?? anime['title']['romaji'] ?? '';
          final format = anime['format'] ?? '';
          final year = anime['startDate']?['year']?.toString() ?? '';

          return GestureDetector(
            onTap: onAnimeTap != null ? () => onAnimeTap!(anime['id']) : null,
            child: SizedBox(
              width: 135,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: anime['coverImage']['large'] ?? '',
                      width: 125,
                      height: 175,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 125,
                        height: 175,
                        color: kcSurfaceColor,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 125,
                        height: 175,
                        color: kcSurfaceColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: kcOffWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    year.isNotEmpty ? '$format • $year' : format,
                    style: GoogleFonts.nunito(
                      color: kcLightGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
