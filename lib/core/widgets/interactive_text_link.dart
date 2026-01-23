import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';

class InteractiveTextLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;

  const InteractiveTextLink({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: style ??
            AppTextStyles.link,
      ),
    );
  }
}
