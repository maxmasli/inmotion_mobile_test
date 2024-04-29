import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';

class RangesWidget extends StatelessWidget {
  RangesWidget({
    super.key,
    required this.width,
    required this.height,
    required this.values,
    required this.builder,
  });

  final double width;
  final double height;
  final List<double> values;
  final Widget Function(double value, int i) builder;

  final colors = [
    AppColors.gray134,
    AppColors.blue,
    AppColors.green,
    AppColors.orange,
    AppColors.red,
  ].map((c) => c.withOpacity(0.3)).toList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(children: [
        for (final (i, value) in values.indexed) ...[
          SizedBox(
            width: width * value,
            height: height,
            child: ColoredBox(
              color: colors[i],
              child: builder(value, i),
            ),
          )
        ]
      ]),
    );
  }
}
