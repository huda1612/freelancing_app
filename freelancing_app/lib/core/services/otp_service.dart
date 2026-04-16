// import 'dart:math';

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<void> sendOTPEmail({
//   required String email,
//   required String otp,
// }) async {
//   const serviceId = "YOUR_SERVICE_ID";
//   const templateId = "YOUR_TEMPLATE_ID";
//   const publicKey = "YOUR_PUBLIC_KEY";

//   final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

//   await http.post(
//     url,
//     headers: {
//       "Content-Type": "application/json",
//     },
//     body: jsonEncode({
//       "service_id": serviceId,
//       "template_id": templateId,
//       "user_id": publicKey,
//       "template_params": {
//         "to_email": email,
//         "otp": otp,
//       }
//     }),
//   );
// }

// String generateOTP() {
//   final random = Random();
//   return (100000 + random.nextInt(900000)).toString();
// }

// bool verifyOTP(String input) {
//   return input == currentOtp;
// }


// onPressed: () async {
//   await controller.startOTP(emailController.text);
// }