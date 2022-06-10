import 'dart:convert';

List<ListPenghuniResponse> listPenghuniResponseFromJson(String str) =>
    List<ListPenghuniResponse>.from(
        json.decode(str).map((x) => ListPenghuniResponse.fromJson(x)));

String listPenghuniResponseToJson(List<ListPenghuniResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListPenghuniResponse {
  ListPenghuniResponse(
      {required this.idPenghuni,
      required this.blok,
      required this.kategori});

  String idPenghuni;
  String blok;
  String kategori;

  factory ListPenghuniResponse.fromJson(Map<String, dynamic> json) =>
      ListPenghuniResponse(
        idPenghuni: json["id_penghuni"],
        blok: json["blok"].toString(),
        kategori: json["kategori"],
      );

  Map<String, dynamic> toJson() => {
        "id_penghuni": idPenghuni,
        "blok": blok,
        "kategori": kategori,
      };
}
