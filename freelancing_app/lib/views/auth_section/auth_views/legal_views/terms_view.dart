import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:get/get.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        title: const Text('شروط الخدمة'),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'أضف هنا نص شروط الخدمة الخاصة بالمنصة.',
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
