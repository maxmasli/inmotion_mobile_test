import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.progressColor,
    required this.backgroundColor,
    required this.loadingWidget,
    required this.loadedWidget,
    this.borderRadius,
    required this.percent,
    required this.onPressed,
    this.padding,
  }) : assert(percent >= 0, "Percent < 0 in LoadingButton!");

  final double percent;
  final Color progressColor;
  final Color backgroundColor;
  final Widget loadingWidget;
  final Widget loadedWidget;
  final BorderRadius? borderRadius;
  final VoidCallback onPressed;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final isLoaded = percent >= 100;
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return SizedBox(
            width: width,
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: GestureDetector(
                onTap: isLoaded ? onPressed : null,
                child: CustomPaint(
                  painter: _LoadingBarPainter(
                    percent: percent,
                    backgroundColor: backgroundColor,
                    progressColor: progressColor,
                  ),
                  child: Padding(
                    padding: padding ?? EdgeInsets.zero,
                    child: Center(
                      child: isLoaded ? loadedWidget : loadingWidget,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoadingBarPainter extends CustomPainter {
  _LoadingBarPainter({
    required this.percent,
    required this.backgroundColor,
    required this.progressColor,
  });

  final double percent;
  final Color backgroundColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(size.width, size.height),
      ),
      backgroundPaint,
    );

    final progressWidth = size.width * (percent.clamp(0, 100) / 100);
    canvas.drawRect(
      Rect.fromPoints(const Offset(0, 0), Offset(progressWidth, size.height)),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
