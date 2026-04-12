// import 'package:http/http.dart' as http;

// Future<bool> checkInternet() async {
//   try {
//     final response = await http
//         .get(Uri.parse('https://www.google.com'))
//         .timeout(const Duration(seconds: 8));

//     // return response.statusCode == 200;
//     return response.statusCode >= 200 && response.statusCode < 400;
//    } catch (_) {
//     return false;
//   }
// }
