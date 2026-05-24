import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';

class CustomRefreshableEmptyMessage extends StatelessWidget {
  const CustomRefreshableEmptyMessage(
      {super.key, required this.onRefresh, required this.emptyMessage});
  final Future<void> Function() onRefresh;
  final String emptyMessage;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.vividPurple,
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: customEmptyMessage(
                message: emptyMessage,
              ),
            ),
          );
        },
      ),
    );
  }
}
