// ignore_for_file: file_names

class CountVisitorModel {
  CountVisitorModel({
    required this.total,
  });

  String total;

  factory CountVisitorModel.fromJson(Map<String, dynamic> json) =>
      CountVisitorModel(
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
      };
}
