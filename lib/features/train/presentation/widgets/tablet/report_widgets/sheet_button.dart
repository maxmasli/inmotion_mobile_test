import 'package:flutter/material.dart';

class SheetButton extends StatelessWidget {
  const SheetButton({
    super.key,
    required this.onPressed,
    this.borderRadius,
    required this.child,
    this.padding,
  });

  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: onPressed != null ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              border: Border.all(
                  color: theme.primaryColor.withOpacity(0.5), width: 1),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 80,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
