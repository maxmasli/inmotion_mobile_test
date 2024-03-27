import 'package:flutter/material.dart';

class TrainTextField extends StatelessWidget {
  const TrainTextField({
    super.key,
    this.hint,
    required this.onChanged,
  });

  final String? hint;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: TextField(
        style: theme.textTheme.titleSmall,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.all(6),
          isCollapsed: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: theme.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.primaryColor),
          ),
        ),
      ),
    );
  }
}
