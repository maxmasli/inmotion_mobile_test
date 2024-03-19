import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 30,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: SizedBox(
          height: size,
          width: size,
          child: InkWell(
            borderRadius: BorderRadius.circular(1000),
            onTap: onPressed,
            child: icon,
          ),
        ),
      ),
    );
  }
}
