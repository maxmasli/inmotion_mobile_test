import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrainTextField extends StatelessWidget {
  const TrainTextField({
    super.key,
    this.hint,
    required this.onChanged,
    required this.controller,
    this.textInputType,
    this.inputFormatters,
    this.enabled = true,
    this.error = false,
  });

  final String? hint;
  final TextEditingController controller;
  final Function(String) onChanged;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      enabled: enabled,
      inputFormatters: inputFormatters,
      keyboardType: textInputType,
      controller: controller,
      textAlign: TextAlign.start,
      style: theme.textTheme.titleSmall,
      onChanged: onChanged,
      decoration: InputDecoration(
        error: error ? const SizedBox.shrink() : null,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
      ),
    );
  }
}
