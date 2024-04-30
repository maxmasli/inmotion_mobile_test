import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';

class NavigateButton extends StatelessWidget {
  const NavigateButton({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final Widget icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      color: isSelected
          ? theme.colorScheme.surface
          : theme.colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: isSelected
                  ? theme.textTheme.bodySmall
                  : theme.textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
