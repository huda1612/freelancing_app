import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';

class CustomLoading extends StatelessWidget {
  final Color loadingColor;
  final double strokeWidth;
  final String? text;
  final double? spaceHeight;

  const CustomLoading(
      {super.key,
      this.loadingColor = AppColors.purple,
      this.strokeWidth = 4.0,
      this.text,
      this.spaceHeight});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      CircularProgressIndicator(
        color: loadingColor,
        strokeWidth: strokeWidth
      ),
      if (text != null) ...[
        SizedBox(height: spaceHeight),
        Text(text!),
      ]
    ]));
  }
}
