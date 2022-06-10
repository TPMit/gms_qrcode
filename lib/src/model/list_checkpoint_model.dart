import 'dart:convert';

List<ListCheckPointModel> listCheckPointModelFromJson(String str) =>
    List<ListCheckPointModel>.from(
        json.decode(str).map((x) => ListCheckPointModel.fromJson(x)));

String listCheckPointModelToJson(List<ListCheckPointModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListCheckPointModel {
  ListCheckPointModel({
    required this.id,
    required this.idSite,
    required this.idUser,
    required this.tanggal,
    required this.status,
    required this.currentdatetime,
  });

  String id;
  String idSite;
  String idUser;
  String tanggal;
  String status;
  DateTime currentdatetime;

  factory ListCheckPointModel.fromJson(Map<String, dynamic> json) =>
      ListCheckPointModel(
        id: json["id"],
        idSite: json["id_site"],
        idUser: json["id_user"],
        tanggal: json["tanggal"],
        status: json["status"],
        currentdatetime: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_site": idSite,
        "id_user": idUser,
        "tanggal": tanggal,
        "status": status,
        "createdAt": currentdatetime.toIso8601String(),
      };
}
