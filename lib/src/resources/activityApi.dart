// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:http/http.dart' show Client;
import 'dart:convert';

import '../response/activity_response.dart';
import '../response/tamu_response.dart';

class ActivityServices {
  Client _client = new Client();
  // ignore: missing_return
  Future<ActivityResponse> getData() async {
    final response = await _client.get(Uri.parse(
        "https://gmsqr.tpm-security.com/attendance/addactivities"));
        print(response.body);
    if (response.statusCode == 200) {
        ActivityResponse activityResponse =
            ActivityResponse.fromJson(json.decode(response.body));
        return activityResponse;
    } else {
      return Future.error("data kosong 🤷‍♂️");
    }
  }
  // Future<List<AcitivityResponse>> getData(String idsite) async {
  //   print(idsite);
  //   try{
  //     final response = await http.get(Uri.parse(
  //         'https://gmsnv.mindotek.com/attendance/listactivitiesidsite/' +
  //             idsite));
  //     print(response.body);
  //     return compute(parseData, response.body);
  //   } catch (e) {
  //     return [];
  //   }
  // }

  // static List<AcitivityResponse> parseData(String responseBody) {
  //   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  //   return parsed
  //       .map<AcitivityResponse>((json) => AcitivityResponse.fromJson(json))
  //       .toList();
  // }

  // static Future<List<VisitorModel>> getDataTamu(String idsite) async {
  //   print(idsite);
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'https://gmsnv.mindotek.com/attendance/listactivitiesvisitor/' +
  //             idsite));

  //     return compute(parseDataTamu, response.body);
  //   } catch (e) {
  //     return [];
  //   }
  // }

  Future<TamuResponse> getDataTamu(String idsite) async {
    try {
      print('go get data tamu');
      final response = await _client.get(Uri.parse(
          "https://gmsnv.mindotek.com/rest/listactivitiesvisitor/$idsite"));
      print(response.body);
      if (response.statusCode == 200) {
        TamuResponse tamuResponse =
            TamuResponse.fromJson(json.decode(response.body));
        return tamuResponse;
      } else {
        return Future.error("data kosong 🤷‍♂️");
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

  // static List<VisitorModel> parseDataTamu(String responseBody) {
  //   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  //   return parsed
  //       .map<VisitorModel>((json) => VisitorModel.fromJson(json))
  //       .toList();
  // }
}