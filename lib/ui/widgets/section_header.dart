import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? color;
  final VoidCallback? onTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kHorizontalPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 4.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    color: color ?? context.colors.primary,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                horizontalSpaceSm,
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: context.textTheme.headlineLarge,
                        ),
                        if (subtitle != null && subtitle!.isNotEmpty) ...[
                          TextSpan(
                            text: '  $subtitle',
                            style: context.textTheme.headlineLarge?.copyWith(
                              fontSize: 18,
                              color: context.colors.outline,
                            ),
                          )
                        ]
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            IconButton(
              onPressed: onTap,
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: context.colors.outline,
              ),
            ),
        ],
      ),
    );
  }
}
