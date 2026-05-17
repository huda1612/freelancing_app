import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/core/utils/helper_function/normalize_numbers.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/offer_service.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:get/get.dart';

class SubmitOfferController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  double projectBudget = 0;
  int projectDurationDays = 0;
  String? projectId;
  String? clientId;
  // Loading state
  bool submitLoading = false;

  /// تعديل عرض موجود (يُمرَّر من صفحة العروض)
  OfferModel? offerToEdit;
  bool get isEditMode => offerToEdit != null;

  @override
  void onInit() {
    super.onInit();
    projectBudget = Get.arguments?["projectBudget"];
    projectDurationDays = Get.arguments?["projectDurationDays"];
    projectId = Get.arguments?['projectId'];
    clientId = Get.arguments?['clientId'];

    offerToEdit = Get.arguments?["offer"] as OfferModel?;
    if (offerToEdit != null) {
      priceController.text = offerToEdit!.price.toString();
      durationController.text = offerToEdit!.durationDays.toString();
      detailsController.text = offerToEdit!.proposalText;
    }
  }

  bool get argsExist {
    if (projectId == null || clientId == null) {
      customSnackbar(
          message: "معلومات المشروع ناقصه ، يرجى اعادة الدخول الى الصفحه");
      return false;
    }
    return true;
  }

  // Submit offer function
  Future<void> submitOffer() async {
    if (!formKey.currentState!.validate()) {
      customSnackbar(message: "يرجى ملئ البيانات بشكل صحيح");
      return;
    }

    if (UserSession.uid == null) {
      Get.snackbar('Unauthorized', 'يجب تسجيل الدخول أولاً');
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    if (!argsExist) {
      return;
    }
    // if (projectId == null || clientId == null) {
    //   customSnackbar(
    //       message: "معلومات المشروع ناقصه ، يرجى اعادة الدخول الى الصفحه");
    //   return;
    // }
    // if(UserSession.role != UserRole.freelancer){
    //   customSnackbar(message: "لست freelancer لا يمكنك ارسال عرض !");
    //   return;
    // }

    submitLoading = true;
    update();

    final res1 = await UserService().fetchUserData2(UserSession.uid!);
    res1.fold((err) {
      customSnackbar(message: "خطأ : ${err.type} / ${err.message}");
      submitLoading = false;
      update();
      return;
    }, (user) async {
      final UserSnapshotModel freelancerSnapshot = UserSnapshotModel(
          fullName: "${user.fname}  ${user.lname}",
          username: user.username,
          jobTitle: user.jobTitle,
          specialization: user.specialization == null
              ? "لا يوجد تخصص محدد"
              : user.specialization!.name,
          rating: user.rating,
          completedProjects: user.completedProjects);
      if (isEditMode) {
        final res2 = await OfferService().updateOffer(
          offerId: offerToEdit!.id,
          newData: {
            'price':
                double.tryParse(normalizeNumbers(priceController.text.trim()))!,
            'duration_days':
                int.parse(normalizeNumbers(durationController.text.trim())),
            'proposal_text': detailsController.text.trim(),
            'freelancerSnapshot': freelancerSnapshot.toMap(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
        if (res2 != StatusClasses.success) {
          customSnackbar(message: "خطأ : ${res2.type} / ${res2.message}");
          submitLoading = false;
          update();
          return;
        }
        Get.back(result: true);
        customSnackbar(message: "تم تحديث العرض بنجاح");
      } else {
        final offer = OfferModel(
          id: '',
          projectId: projectId!,
          freelancerId: UserSession.uid!,
          clientId: clientId!,
          freelancerSnapshot: freelancerSnapshot,
          price:
              double.tryParse(normalizeNumbers(priceController.text.trim()))!,
          proposalText: detailsController.text.trim(),
          durationDays:
              int.parse(normalizeNumbers(durationController.text.trim())),
          createdAt: null,
        );
        final res2 = await OfferService().addOffer(offer: offer);
        if (res2 != StatusClasses.success) {
          customSnackbar(message: "خطأ : ${res2.type} / ${res2.message}");
          submitLoading = false;
          update();
          return;
        }
        Get.back(result: true);
        customSnackbar(
          message: "تم تقديم العرض بنجاح",
        );
      }
      // Clear fields after success
      priceController.clear();
      durationController.clear();
      detailsController.clear();

      submitLoading = false;
      update();
    });
  }

  bool _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return true;
    }
    return false;
  }

  String? priceValidation(String? val) {
    if (_validateRequired(val)) {
      return "يجب ادخال قيمة مبلغ العرض";
    }
    final parsed = double.tryParse(normalizeNumbers(val!.trim()));
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
    if (_validateRequired(val)) {
      return "يجب ادخال قيمة مدة التسليم";
    }
    final parsed = double.tryParse(normalizeNumbers(val!.trim()));
    if (parsed == null || parsed <= 0) {
      return 'المدة يجب أن تكون رقمًا أكبر من 0';
    }
    if (parsed > projectDurationDays) {
      return 'يجب ان لا تتجاوز مدة المشروع وهي $projectDurationDays';
    }
    return null;
  }

  String? descriptionValidation(String? val) {
    if (_validateRequired(val)) {
      return "يجب ادخال تفاصيل العرض";
    }
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
