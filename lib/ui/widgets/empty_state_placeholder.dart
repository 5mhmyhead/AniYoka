import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class EmptyStatePlaceholder extends StatefulWidget {
  final String title;

  const EmptyStatePlaceholder({super.key, required this.title});

  @override
  State<EmptyStatePlaceholder> createState() => _EmptyStatePlaceholderState();
}

class _EmptyStatePlaceholderState extends State<EmptyStatePlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 30),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _controller,
            child: Container(
              width: 250,
              height: 250,
              decoration: ShapeDecoration(
                color: context.colors.surfaceContainer,
                shape: StarBorder(
                  points: 10,
                  innerRadiusRatio: 0.80,
                  valleyRounding: 0.2,
                  pointRounding: 0.5,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 170,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                height: 1.25,
              )
            ),
          ),
        ],
      ),
    );
  }
}