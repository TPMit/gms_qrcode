import 'dart:convert';

List<ListMemberModel> listMemberModelFromJson(String str) =>
    List<ListMemberModel>.from(
        json.decode(str).map((x) => ListMemberModel.fromJson(x)));

String listMemberModelToJson(List<ListMemberModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListMemberModel {
  ListMemberModel({
    required this.nik,
    required this.name,
  });

  String nik;
  String name;

  factory ListMemberModel.fromJson(Map<String, dynamic> json) =>
      ListMemberModel(
        nik: json["nik"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "name": name,
      };
}
