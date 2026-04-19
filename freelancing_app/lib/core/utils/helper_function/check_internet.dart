import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

Future<bool> checkInternet() async {
  try {
    // final response = await http
    //     .get(Uri.parse('https://www.google.com'))
    //     .timeout(const Duration(seconds: 8));
    await FirebaseFirestore.instance.doc('test/ping').get();
    return true;
    // return response.statusCode >= 200 && response.statusCode < 400;
  } catch (e) {
    // print("################################################################" +
    //     e.toString());
    return false;
  }
}
