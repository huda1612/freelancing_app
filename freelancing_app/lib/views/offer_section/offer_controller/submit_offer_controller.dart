import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/utils/helper_function/normalize_numbers.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class SubmitOfferController extends GetxController {
  // Controllers for text fields
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  double projectBudget = 0;
  int projectDurationDays = 0;
  // Loading state
  bool submitLoading = false;

  @override
  void onInit() {
    super.onInit();
    projectBudget = Get.arguments?["projectBudget"];
    projectDurationDays = Get.arguments?["projectDurationDays"];
  }

  // Submit offer function
  Future<void> submitOffer() async {
    final price = priceController.text.trim();
    final duration = durationController.text.trim();
    final details = detailsController.text.trim();

    // Validation
    if (price.isEmpty || duration.isEmpty || details.isEmpty) {
      customSnackbar(
        message: "يرجى تعبئة جميع الحقول",
      );
      return;
    }

    submitLoading = true;

    customSnackbar(
      message: "تم تقديم العرض بنجاح",
    );

    // Clear fields after success
    priceController.clear();
    durationController.clear();
    detailsController.clear();

    submitLoading = false;
  }

  String? priceValidation(String? val) {
    if (val == null || val.trim().isEmpty) {
      return "يجب ادخال قيمة مبلغ العرض";
    }
    final parsed = double.tryParse(normalizeNumbers(val.trim()));
    if (parsed == null || parsed <= 0) {
      return 'العرض يجب أن يكون رقمًا أكبر من 0';
    }
    if (parsed > projectBudget) {
      return 'يجب ان لا يتجاوز العرض قيمة ميزانية المشروع وهي $projectBudget';
    }
    return null;
  }
  //   String? validateBudget(String? value) {
  //   final emptyError = validateRequired(value, 'الميزانية');
  //   if (emptyError != null) return emptyError;
  //   // final parsed = double.tryParse(value!.trim());
  //   final parsed = double.tryParse(_normalizeNumbers(value!.trim()));
  //   if (parsed == null || parsed <= 0) {
  //     return 'الميزانية يجب أن تكون رقمًا أكبر من 0';
  //   }
  //   return null;
  // }

  String? durationValidation(String? val) {
    return null;
  }
  String? descriptionValidation(String? val) {
    return null;
  }

  @override
  void onClose() {
    priceController.dispose();
    durationController.dispose();
    detailsController.dispose();
    super.onClose();
  }
}
