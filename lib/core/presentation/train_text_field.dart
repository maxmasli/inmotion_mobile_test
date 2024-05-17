import 'dart:developer';

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
  });

  final String? hint;
  final TextEditingController controller;
  final Function(String) onChanged;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      inputFormatters: inputFormatters,
      keyboardType: textInputType,
      controller: controller,
      textAlign: TextAlign.center,
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
    );
  }
}
