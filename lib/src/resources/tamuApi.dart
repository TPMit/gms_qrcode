// ignore_for_file: avoid_print, file_names

import 'dart:io';

import 'package:http/http.dart' as http;

import '../response/visitor_count_response.dart';

class VisitorService {
  Future<List<CountVisitorResponse>> getData(String param) async {
    try {
      final response = await http.get(Uri.parse(
          "https://gmsnv.mindotek.com/attendance/countTamu/?idsite=$param"));
      print(param);
      if (200 == response.statusCode) {
        final List<CountVisitorResponse> data =
            countVisitorResponseFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } on SocketException {
      return Future.error("Yah, Internet Kamu error!😑");
    } on HttpException {
      print("Fungsi post ga nemu 😱");
      // return Future.error("Fungsi post ga nemu 😱");
      return Future.error("terjadi error");
    } on FormatException {
      print("Response format kacauu! 👎");
      // return Future.error("Response format kacauu! 👎");
      return Future.error("terjadi error");
    }
  }
}