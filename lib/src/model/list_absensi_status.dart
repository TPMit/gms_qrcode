import 'dart:convert';

List<ListAbsensiStatus> listAbsensiStatusFromJson(String str) =>
    List<ListAbsensiStatus>.from(
        json.decode(str).map((x) => ListAbsensiStatus.fromJson(x)));

String listAbsensiStatusToJson(List<ListAbsensiStatus> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListAbsensiStatus {
  ListAbsensiStatus({
    required this.id,
    required this.code,
    required this.keterangan,
  });

  String id;
  String code;
  String keterangan;

  factory ListAbsensiStatus.fromJson(Map<String, dynamic> json) =>
      ListAbsensiStatus(
        id: json["id"],
        code: json["code"],
        keterangan: json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "keterangan": keterangan,
      };
}
