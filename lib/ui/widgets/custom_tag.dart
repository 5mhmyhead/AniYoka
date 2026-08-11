import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

// note: i was going to use ChipTheme for custom badges, but had a lot of
// material 3 quirks that i didn't want to deal with
class CustomTag extends StatelessWidget {
  final Widget label;
  final Widget? icon;

  const CustomTag({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(icon != null) ...[
            icon!,
            SizedBox(width: 4.0),
          ],
          DefaultTextStyle(
            style: context.textTheme.labelSmall ?? const TextStyle(), 
            child: label,
          )
        ],
      ),
    );
  }
}
