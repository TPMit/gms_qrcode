
// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import '../model/list_absen_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;

import '../model/list_absensi_status.dart';
import '../model/list_member_model.dart';
// import '../model/list_penghuni.dart';
import '../response/keperluan_response.dart';
import '../response/penghuni_response.dart';

class ListAbsenService {
  Client _client = new Client();
  static Future<List<ListAbsenModel>> get(String param) async {
    print('get list absen');
    try {
      print("idniknya $param");
      final response = await http.get(Uri.parse(
          "https://gmsnv.mindotek.com/attendance/listabsenidsite/$param"));
      if (200 == response.statusCode) {
        final List<ListAbsenModel> data = listAbsenModelFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<ListMemberModel>> getMember(String param) async {
    try {
      print(param);
      final response = await http.get(Uri.parse(
          "https://gmsnv.mindotek.com/attendance/listmember/$param"));
      if (200 == response.statusCode) {
        final List<ListMemberModel> data =
            listMemberModelFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<PenghuniResponse> getMemberPenghuni(String query) async {
      if(query != ''){
        print(query);
        final response = await http.get(Uri.parse(
            "https://gmsnv.mindotek.com/rest/listmemberPenghuni/?param=$query"));
         if (response.statusCode == 200) {
          print('penghuni:');
          print(response.body);
          PenghuniResponse penghuniResponse =
              PenghuniResponse.fromJson(json.decode(response.body));
          return penghuniResponse;
        } else {
          return Future.error("Yah, Internet Kamu error!");
        }
      }else{
        final response = await http.get(Uri.parse(
            "https://gmsnv.mindotek.com/rest/listmemberPenghuni/"));
        if (response.statusCode == 200) {
          print('penghuni:');
          print(response.body);
          PenghuniResponse penghuniResponse =
              PenghuniResponse.fromJson(json.decode(response.body));
          return penghuniResponse;
        } else {
          return Future.error("Yah, Internet Kamu error!");
        }
      }
  }

  Future<KeperluanResponse> getKeperluan(String param) async {
    print(param);
      if(param != ''){
        final response = await _client.get(Uri.parse(
          "https://gmsnv.mindotek.com/rest/listKeperluan/param=$param"));
      if (response.statusCode == 200) {
        print('keperluan:');
        print(response.body);
        KeperluanResponse keperluanResponse =
            KeperluanResponse.fromJson(json.decode(response.body));
        return keperluanResponse;
      } else {
        return Future.error("Yah, Internet Kamu error!");
      }
      }else{
        final response = await _client.get(Uri.parse(
            "https://gmsnv.mindotek.com/rest/listKeperluan/"));
        if (response.statusCode == 200) {
          print('keperluan:');
          print(response.body);
          KeperluanResponse keperluanResponse =
              KeperluanResponse.fromJson(json.decode(response.body));
          return keperluanResponse;
        } else {
          return Future.error("Yah, Internet Kamu error!");
        }
      }
  }

  static Future<List<ListAbsensiStatus>>? getAbsensiStatus() async {
    try {
      final response = await http.get(Uri.parse(
          "https://gmsnv.mindotek.com/attendance/listabsenstatus"));
      if (200 == response.statusCode) {
        final List<ListAbsensiStatus> data =
            listAbsensiStatusFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
