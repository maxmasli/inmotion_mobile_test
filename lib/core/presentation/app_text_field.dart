import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.leading,
    this.hintText,
    required this.controller,
    this.obscureText = false,
    this.inputFormatters,
  });

  final Widget leading;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 42, maxHeight: 42),
          child: Row(
            children: [
              SizedBox(
                width: 95,
                child: leading,
              ),
              Expanded(
                child: TextField(
                  inputFormatters: inputFormatters,
                  style: theme.textTheme.labelMedium,
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                      hintText: hintText,
                      isCollapsed: true,
                      counterStyle: theme.textTheme.titleSmall,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}