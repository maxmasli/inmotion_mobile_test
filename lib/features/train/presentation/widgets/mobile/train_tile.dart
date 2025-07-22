import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:intl/intl.dart';

class TrainTile extends StatelessWidget {
  TrainTile({
    super.key,
    required this.train,
    required this.onPressed,
  });

  final TrainEntity train;
  final VoidCallback onPressed;
  final formatTime = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            formatTime.format(train.startTime),
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              train.trainName,
              style: theme.textTheme.displayMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _SheetButton(
            padding: const EdgeInsets.all(4),
            onPressed: onPressed,
            child: Center(
              child: Text(
                "Excel",
                style: theme.textTheme.titleSmall,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    super.key,
    required this.onPressed,
    this.borderRadius,
    required this.child,
    this.padding,
  });

  final VoidCallback onPressed;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.5), width: 3),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 80,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
