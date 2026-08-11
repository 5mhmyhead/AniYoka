import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;
  final VoidCallback? onTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
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
              Text(
                title, 
                style: context.textTheme.headlineLarge,
              ),
            ],
          ),
          if(onTap != null) IconButton(
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
