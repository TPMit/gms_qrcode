
import 'dart:convert';

List<CountVisitorResponse> countVisitorResponseFromJson(String str) =>
    List<CountVisitorResponse>.from(
        json.decode(str).map((x) => CountVisitorResponse.fromJson(x)));

String countVisitorResponseToJson(List<CountVisitorResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountVisitorResponse {
  CountVisitorResponse({
    required this.total,
  });

  String total;

  factory CountVisitorResponse.fromJson(Map<String, dynamic> json) =>
      CountVisitorResponse(
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
      };
}
