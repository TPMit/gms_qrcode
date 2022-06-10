// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import '../model/list_checkpoint_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;

import '../response/checkpointAll_response.dart';
import '../response/checkpointTagResponse.dart';

class ListCheckPointService {
  Client _client = new Client();

  Future<CheckpointAllResponse> getDataCheckPointAll() async {
    final response = await _client.get(
        Uri.parse("https://gmsnv.mindotek.com/rest/listcheckpointall/"));
    print(response.body);
    if (response.statusCode == 200) {
      CheckpointAllResponse checkpointAllResponse =
          CheckpointAllResponse.fromJson(json.decode(response.body));
      return checkpointAllResponse;
    } else {
      return Future.error("Yah, Internet Kamu error!");
    }
  }
  
  static Future<List<ListCheckPointModel>> get(String param) async {
    print('===='+param);
    try {
      print('get checkout');
      final response = await http.get(Uri.parse(
          "https://gmsnv.mindotek.com/attendance/listcheckpointidsite?idUser=$param"));
      print(response.body);
      if (200 == response.statusCode) {
        final List<ListCheckPointModel> data =
            listCheckPointModelFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<QrcodeTagResponse> getHistoryCheckPoints(String idCheckpoint) async {
    print('getdata');
    print(idCheckpoint);
    final response = await http.get(Uri.parse(
        "https://gmsnv.mindotek.com/rest/listcheckpoint?idCheckpoint=$idCheckpoint"));
    print(response.body);
    Map<String, dynamic> res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (res['success']) {
        QrcodeTagResponse qrcodeTagResponse =
            QrcodeTagResponse.fromJson(json.decode(response.body));
        return qrcodeTagResponse;
      } else {
        return res['data'];
      }
    } else {
      return res['data'];
    }
  }

  static Future postCheckPoint(
     String idCheck, String tagId, int isKondusif, String desc) async {
    final response = await http.post(
        Uri.parse('https://gmsnv.mindotek.com/Rest/checkpointbyqr'),
        body: {
          'idCheck':idCheck,
          'tagid_user': tagId,
          'isclear': isKondusif.toString(),
          'note': desc
        });
        print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.body);
      print(res['status']);
      print("Post CheckPoint");
      if (res['status'] == true) {
        return res['data'];
      } else {
        Future.error("${res['data']}");
      }
    } else {
      Future.error("Yah, Internet kamu error!");
    }
  }

  static Future<int> newCheckpoint(String idUser, String idSite) async {
    final response = await http.post(Uri.parse(
        "https://gmsnv.mindotek.com/rest/newCheckpoint"),
        body: {
          'idUser': idUser,
          'idSite': idSite,
        });
    if (response.body.isNotEmpty) {
      Map<String, dynamic> res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("New Checkpoint");
        if (res['success']) {
          return int.parse(res['data']);
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  static Future<int> checkEmpty(String idTag) async {
      final response = await http.get(Uri.parse(
          "https://gmsnv.mindotek.com/rest/checkEmptyCheckPoint?idTag=$idTag"));
    if (response.body.isNotEmpty) {
      Map<String, dynamic> res = jsonDecode(response.body);
      if (response.statusCode == 200) {
      print("Check Empty");
      if (res['success']) {
        return res['data'];
      } else {
        return 0;
      }
    } else {
      return 0;
    }
    }else{
      return 0;
    }
  }

}
