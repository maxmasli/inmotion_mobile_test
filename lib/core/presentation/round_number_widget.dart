import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';



class RoundNumberWidget extends StatelessWidget {
  const RoundNumberWidget({
    super.key,
    required this.number,
    this.color = AppColors.gray186,
  });

  final int? number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Center(
        child: Text(
          (number ?? "-").toString(),
          style: theme.textTheme.displaySmall?.copyWith(color: color),
        ),
      ),
    );
  }
}
