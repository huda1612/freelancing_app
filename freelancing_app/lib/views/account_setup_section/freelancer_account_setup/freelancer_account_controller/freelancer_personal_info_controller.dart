import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FreelancerPersonalInfoController extends GetxController {
  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  // Reactive fields
  final gender = RxnString();
  final year = RxnString();
  final month = RxnString();
  final day = RxnString();
  final agreed = false.obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Reactive validation
  bool get isFormValid {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        gender.value != null &&
        year.value != null &&
        month.value != null &&
        day.value != null &&
        agreed.value;
  }

  // Trigger UI update
  void refreshForm() {
    update(); // For GetBuilder
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
