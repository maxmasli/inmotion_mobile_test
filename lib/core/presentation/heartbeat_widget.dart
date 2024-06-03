import 'package:flutter/material.dart';

class HeartbeatWidget extends StatefulWidget {
  const HeartbeatWidget(
      {super.key, required this.child, required this.frequency});

  final Widget child;
  final int frequency;

  @override
  State<HeartbeatWidget> createState() => _HeartbeatWidgetState();
}

class _HeartbeatWidgetState extends State<HeartbeatWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (1 / (widget.frequency / 60) * 1000).round()),
    );

    _animation = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceIn),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}