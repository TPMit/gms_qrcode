// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/emergency_contact_model.dart';

class ContactServices {
  static Future<List<ContactModel>> getData() async {
    try{
      final response = await http.get(Uri.parse(
          'https://gmsnv.mindotek.com/attendance/listemergencycontact'));

      return compute(parseData, response.body);
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

  static List<ContactModel> parseData(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ContactModel>((json) => ContactModel.fromJson(json))
        .toList();
  }
}