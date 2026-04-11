import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';

class BaseScreen extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  const BaseScreen({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.softPurple,
            AppColors.softBlue,
          ],
           begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar ??
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
