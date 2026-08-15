import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onTap;

  const ErrorStateWidget({
    super.key,
    this.title = 'Error!',
    this.subtitle = 'An error has occurred.',
    this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: kHorizontalPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: context.textTheme.displayMedium?.copyWith(
                color: context.colors.secondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              verticalSpaceSm,
              Text(
                subtitle!,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colors.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onTap != null) ...[
              verticalSpaceLg,
              FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.surfaceContainer,
                  overlayColor: context.colors.outline,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 15.0,
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.colors.outline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}