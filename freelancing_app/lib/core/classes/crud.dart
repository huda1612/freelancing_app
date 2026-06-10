import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'status_classes.dart';

class Crud {
  static Future<Either<StatusClasses, String>> postData(
      {required String uri,
      required Map body,
      required Map<String, String> headers,
      required bool withData}) async {
    try {
      var url = Uri.parse(uri);
      var response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      Map<String, dynamic> decodedResponse;
      try {
        print(response.body);
        decodedResponse = json.decode(response.body);
      } catch (e) {
        debugPrint("error in the response format from server");
        return Left(StatusClasses.customError(
            "error in the response format from server"));
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        //الاتصال نجح
        var data = withData
            ? response.body
            : (decodedResponse['message'] ?? "No message");
        return Right(data);
      } else if (response.statusCode == 401) {
        return const Left(StatusClasses.unauthorized);
      } else {
        var message = decodedResponse['message'] ?? "an error occured";
        debugPrint(message);
        return Left(StatusClasses.customError(message));
      }
    } on SocketException {
      debugPrint("Network error");
      return Left(StatusClasses.customError("Network error"));
    } catch (e) {
      debugPrint("An unexpected error occured $e");
      return Left(StatusClasses.customError("An unexpected error occured"));
    }
  }

  static Future<Either<StatusClasses, String>> getData(
      String uri, Map<String, String> headers) async {
    try {
      // if (await checkInternet()) {
      var url = Uri.parse(uri);
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.body);
      } else if (response.statusCode == 401) {
        return const Left(StatusClasses.unauthorized);
      } else {
        print("STATUS CODE: ${response.statusCode}");
        print("BODY: ${response.body}");
        return const Left(StatusClasses.serverError);
      }
      // } else {
      //   return const Left(StatusClasses.offlineError);
      // }
    } catch (e) {
      return Left(StatusClasses.customError("an unexpected error occured"));
    }
  }
}
