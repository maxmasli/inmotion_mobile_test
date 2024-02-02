import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onTap,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: theme.colorScheme.tertiaryContainer,
            ),
            padding: padding,
            width: width,
            height: height,
            child: child,
          ),
        ),
      ),
    );
  }
}
