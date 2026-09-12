import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final String label;

  final bool isRequired;

  const LabelWidget({super.key, required this.label, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodySmall;
    final defaultStyle = baseStyle?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final style = theme.inputDecorationTheme.floatingLabelStyle ?? defaultStyle;

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: label),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: style?.copyWith(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
