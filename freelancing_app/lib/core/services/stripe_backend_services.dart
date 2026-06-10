import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_constant_data.dart';
import 'package:http/http.dart' as http;

class StripeServices {
  static String createFullAccountUrl =
      '${AppConstantData.host}/create-account-and-link';
  static String accountStatusUrl = '${AppConstantData.host}/account-status';

  static String accountLinkUrl = '${AppConstantData.host}/create-account-link';

  static String dashboardLinkUrl = '${AppConstantData.host}/dashboard-link';
  static String createPaymentIntentUrl =
      '${AppConstantData.host}/payment-intent';
  static String createCheckoutUrl =
      '${AppConstantData.host}/create-checkout-session';

  static Map<String, String> headers = {'Content-Type': 'application/json'};

  ///انشاء حساب بstrip connect ورد الرابط و الاي دي للحساب
  static Future<Either<StatusClasses, Map<String, dynamic>>>
      createStripeConnectAccountAndLink() async {
    final response = await Crud.postData(
      uri: createFullAccountUrl,
      body: {},
      headers: headers,
      withData: true,
    );

    return response.fold(
      (e) => Left(e),
      (data) {
        final body = jsonDecode(data);

        return Right({
          "accountId": body['accountId'],
          "url": body['url'],
        });
      },
    );
  }

  ///للتأكد اذا كمل اعداد الحساب
  static Future<Either<StatusClasses, Map<String, dynamic>>>
      checkStripeAccountStatus(String accountId) async {
    final response = await Crud.postData(
      uri: accountStatusUrl,
      body: {"accountId": accountId},
      headers: headers,
      withData: true,
    );

    return response.fold(
      (e) => Left(e),
      (data) {
        final body = jsonDecode(data);
        print({
          "accountId": body["accountId"],
          'stripeOnboardingCompleted': body['stripeOnboardingCompleted'],
          'charges_enabled': body['charges_enabled'],
          "payouts_enabled": body['payouts_enabled'],
          "currently_due": body["currently_due"],
          "eventually_due": body["eventually_due"],
          "disabled_reason": body["disabled_reason"],
          "business_type": body["business_type"],
        });
        return Right({
          "stripeOnboardingCompleted": body['stripeOnboardingCompleted'],
          "charges_enabled": body['charges_enabled'],
          "payouts_enabled": body['payouts_enabled'],
        });
      },
    );
  }

  static Future<Either<StatusClasses, Map<String, dynamic>>>
      createStripeOnboardingLink(String accountId) async {
    final response = await Crud.postData(
      uri: accountLinkUrl,
      body: {"accountId": accountId},
      headers: headers,
      withData: true,
    );

    return response.fold(
      (e) => Left(e),
      (data) {
        final body = jsonDecode(data);

        return Right({
          "url": body['url'],
        });
      },
    );
  }

  static Future<Either<StatusClasses, String>> createDashboardLink(
      String accountId) async {
    final response = await Crud.postData(
      uri: dashboardLinkUrl,
      body: {
        "accountId": accountId,
      },
      headers: headers,
      withData: true,
    );

    return response.fold(
      (e) => Left(e),
      (data) {
        final body = jsonDecode(data);
        return Right(body['url']);
      },
    );
  }

  static Future<Either<StatusClasses, Map<String, dynamic>>>
      createPaymentIntent(double amount, String accountId) async {
    final res = await http.get(Uri.parse("http://10.0.2.2:3000"));
    print("jfdkl;gjfkldsjgfkdlgjlsfkdgj");
    print(res.body);
    final response = await Crud.postData(
      uri: createPaymentIntentUrl,
      body: {"amount": amount, "accountId": accountId},
      headers: headers,
      withData: true,
    );

    return response.fold(
      (e) => Left(e),
      (data) {
        final body = jsonDecode(data);

        return Right({
          "clientSecret": body['clientSecret'],
        });
      },
    );
  }

//ما مستخدم
  static Future<Either<StatusClasses, String>> createCheckoutSession(
    int amount,
    String accountId,
    String taskId,
  ) async {
    final response = await Crud.postData(
      uri: createCheckoutUrl,
      body: {
        "amount": amount,
        "accountId": accountId,
        "taskId": taskId,
      },
      headers: headers,
      withData: true,
    );

    return response.fold(
      (e) => Left(e),
      (data) {
        final body = jsonDecode(data);
        return Right(body["url"]);
      },
    );
  }
}

// static Future<CheckoutSessionResponse> payForProduct(
//     Product product, String accountId) async {
//   var url = StripeServices.checkoutSessionUrl +
//       "&account_id=$accountId&amount=${product.price}&title=${product.title}&quantity=1&currency=${product.currency}";
//   Uri parsedUrl = Uri.parse(url);
//   var response =
//       await http.get(parsedUrl, headers: StripeServices.headers);
//   Map<String, dynamic> body = jsonDecode(response.body);
//   return CheckoutSessionResponse(body['session']);
// }
