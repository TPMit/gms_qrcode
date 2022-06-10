import 'dart:convert';

List<ListAbsenModel> listAbsenModelFromJson(String str) =>
    List<ListAbsenModel>.from(
        json.decode(str).map((x) => ListAbsenModel.fromJson(x)));

String listAbsenModelToJson(List<ListAbsenModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListAbsenModel {
  ListAbsenModel({
    required this.attid,
    required this.currentdatetime,
    required this.lokasi,
    required this.idUser,
    required this.isin,
    required this.thetime,
    required this.name,
  });

  String attid;
  DateTime currentdatetime;
  String idUser;
  String isin;
  String thetime;
  String name;
  String lokasi;

  factory ListAbsenModel.fromJson(Map<String, dynamic> json) => ListAbsenModel(
        attid: json["id_att"],
        currentdatetime: DateTime.parse(json["datetime_in"]),
        lokasi: json["lokasi"],
        idUser: json["id_user"],
        isin: json["is_in"],
        thetime: json["thetime"],
        name: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id_att": attid,
        "datetime_in": currentdatetime.toIso8601String(),
        "lokasi": lokasi,
        "id_user": idUser,
        "is_in": isin,
        "thetime": thetime,
        "username": name,
      };
}
