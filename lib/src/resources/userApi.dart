// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import '../response/login_response.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<PostResult> connectToApi(String email, String password) async {
    String apiURL = "https://gmsnv.mindotek.com/rest/personil_auth";

    var apiResult = await http
        .post(Uri.parse(apiURL), body: {"username": email, "password": password});
    var jsonObject = json.decode(apiResult.body);
    print(jsonObject);

    return PostResult.createPostResult(jsonObject);
  }
}
