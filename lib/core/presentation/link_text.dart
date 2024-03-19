import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  const LinkText(
      this.text, {
        required this.onTap,
        this.textAlign = TextAlign.start,
        super.key,
      });

  final String text;
  final VoidCallback onTap;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        text: text,
        style: theme.textTheme.displaySmall,
        recognizer: TapGestureRecognizer()..onTap = onTap,
      ),
    );
  }
}