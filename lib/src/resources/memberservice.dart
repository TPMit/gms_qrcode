import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class MemberService {
  static Future<List<ListMembersModel>> get(String param) async {
    try {
      final response = await http.get(Uri.parse(
          "https://gmsnv.mindotek.com/attendance/listmember/" + param));
      if (200 == response.statusCode) {
        final List<ListMembersModel> data =
            listMemberModelFromJson(response.body);
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

List<ListMembersModel> listMemberModelFromJson(String str) =>
    List<ListMembersModel>.from(
        json.decode(str).map((x) => ListMembersModel.fromJson(x)));

String listMemberModelToJson(List<ListMembersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListMembersModel {
  ListMembersModel({
    required this.idUser,
    required this.nik,
    required this.username,
    required this.idSite,
    required this.idPosition,
  });

  String idUser;
  String nik;
  String username;
  String idSite;
  String idPosition;

  factory ListMembersModel.fromJson(Map<String, dynamic> json) =>
      ListMembersModel(
        idUser: json["id_user"],
        nik: json["nik"] == null ? '0' : json["nik"].toString(),
        username: json["username"],
        idSite: json["id_site"],
        idPosition: json["id_position"],
      );

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "name": username,
      };
}
