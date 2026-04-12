import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';

class UiStateHandler extends StatelessWidget {
  final StatusClasses? status;
  final Widget Function() onSuccess;

  const UiStateHandler({
    super.key,
    required this.status,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return onSuccess();
    }

    if (status == StatusClasses.isloading) {
      return CustomLoading();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.close, color: Colors.red),
          const SizedBox(height: 10),
          Text(status!.message ?? "Error"),
        ],
      ),
    );
  }
}
