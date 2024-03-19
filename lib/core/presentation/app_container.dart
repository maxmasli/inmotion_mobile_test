import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    this.onTap,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    required this.child,
  });

  final VoidCallback? onTap;
  final Color? color;
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: PhysicalModel(
        color: color ?? theme.colorScheme.primaryContainer,
        borderRadius: borderRadius,
        elevation: 2,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Ink(
              padding: padding,
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: color ?? theme.colorScheme.primaryContainer,
                borderRadius: borderRadius,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
