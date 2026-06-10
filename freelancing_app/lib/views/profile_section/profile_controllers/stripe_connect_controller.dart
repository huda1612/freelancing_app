import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/services/stripe_backend_services.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/views/profile_section/profile_widgets/complete_stripe_setup_bottom_sheet.dart';
import 'package:freelancing_platform/views/profile_section/profile_widgets/payment_account_ready_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeConnectController extends GetxController {
  final isLoading = false.obs;
  final openSheetIsLoading = false.obs;

  // var accountId = RxnString();
  // var onboardingUrl = RxnString();
  var errorState = Rxn<StatusClasses>(null);
  final UserService _userService = UserService();

  /// CREATE ACCOUNT + GET ONBOARDING LINK (FULL FLOW)
  Future<void> createAccountAndOpenLink() async {
    try {
      isLoading.value = true;
      errorState.value = null;

      final result = await StripeServices.createStripeConnectAccountAndLink();

      result.fold(
        (failure) {
          errorState.value = failure;
        },
        (data) async {
          final accountId = data['accountId'];
          final onboardingUrl = data['url'];

          final res = await _userService.updateUserData2({
            "stripeAccountId": accountId,
            "stripeOnboardingCompleted": false
          }, UserSession.uid!);
          if (res == StatusClasses.success) {
            await _openUrl(onboardingUrl);
          } else {
            customSnackbar(message: "حدث خطأ:${res.message ?? res.type}");
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// OPEN STRIPE LINK
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      errorState.value =
          StatusClasses.customError("Cannot open onboarding link");
    }
  }

  Future<void> onOpenStripeAccountSettings(
    bool? stripeOnboardingCompleted,
    String accountId,
  ) async {
    bool completed = stripeOnboardingCompleted ?? false;

    if (!completed) {
      try {
        openSheetIsLoading.value = true;
        errorState.value = null;

        final statusRes =
            await StripeServices.checkStripeAccountStatus(accountId);

        await statusRes.fold(
          (err) async {
            errorState.value = err;
            customSnackbar(
              message: "خطأ: ${err.message ?? err.type}",
            );
          },
          (data) async {
            completed = data["stripeOnboardingCompleted"] == true;

            if (completed) {
              final res = await _userService.updateUserData2(
                {"stripeOnboardingCompleted": true},
                UserSession.uid!,
              );

              if (res != StatusClasses.success) {
                customSnackbar(
                  message: "حدث خطأ: ${res.message ?? res.type}",
                );
              }
            }
          },
        );
      } finally {
        openSheetIsLoading.value = false;
      }
    }

    if (!completed) {
      // افتح شاشة BottomSheet إكمال إعداد الحساب
      Get.bottomSheet(Obx(() => CompleteStripeSetupBottomSheet(
          isLoading: isLoading.value,
          onContinuePressed: () async {
            final url = await _createOnboardingLink(accountId);
            if (url == null) return;
            _openUrl(url);
          })));
      return;
    }

    // افتح شاشة إدارة حساب الدفع
    Get.bottomSheet(Obx(() => PaymentAccountReadyBottomSheet(
        isLoading: isLoading.value,
        onOpenStripePressed: () async {
          final url = await _createDashBoardLink(accountId);
          if (url == null) return;
          _openUrl(url);
        })));
    return;
  }

  Future<String?> _createOnboardingLink(String accountId) async {
    isLoading.value = true;

    final result = await StripeServices.createStripeOnboardingLink(accountId);

    return result.fold(
      (e) {
        errorState.value = e;
        customSnackbar(message: "خطأ:${e.message ?? e.type}");
        isLoading.value = false;
        return null;
      },
      (data) {
        isLoading.value = false;
        return data['url'];
      },
    );
  }

  Future<String?> _createDashBoardLink(String accountId) async {
    isLoading.value = true;

    final result = await StripeServices.createDashboardLink(accountId);

    return result.fold(
      (e) {
        errorState.value = e;
        customSnackbar(message: "خطأ:${e.message ?? e.type}");
        isLoading.value = false;
        return null;
      },
      (url) {
        isLoading.value = false;
        return url;
      },
    );
  }
}
