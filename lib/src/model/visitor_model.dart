class VisitorModel {
  VisitorModel({
    required this.id,
    required this.noVisitor,
    required this.tamu,
    required this.tanggal,
    required this.jam,
    required this.idPenghuni,
    required this.keteranganPerlu,
    required this.images,
    required this.idUser,
    required this.status,
    required this.name,
    required this.dateTime,
    required this.blok,
    required this.penghuni,
  });

  String id;
  String noVisitor;
  String tamu;
  String tanggal;
  String jam;
  String idPenghuni;
  String keteranganPerlu;
  String images;
  String idUser;
  String status;
  String name;
  DateTime dateTime;
  String blok;
  String penghuni;

  factory VisitorModel.fromJson(Map<String, dynamic> json) => VisitorModel(
        id: json["id_tamu"],
        noVisitor: json["no_visitor"],
        tamu: json["tamu"],
        tanggal: json["tanggal"],
        jam: json["jam"],
        idPenghuni: json["id_penghuni"],
        keteranganPerlu: json["keterangan_perlu"] != null ? json["keterangan_perlu"] : '',
        images: json["images"] != null ? json["images"] : '',
        idUser: json["id_user"],
        status: json["status"],
        dateTime: DateTime.parse(json["tanggal"]),
        name: json["nama"], 
        blok: json["blok"],
        penghuni: json["penghuni"],
      );

  Map<String, dynamic> toJson() => {
        "id_tamu": id,
        "no_visitor":noVisitor,
        "tamu": tamu,
        "tanggal": tanggal,
        "jam": jam,
        "id_penghuni": idPenghuni,
        "keterangan_perlu": keteranganPerlu,
        "images": images,
        "id_user": idUser,
        "status": status,
        "dateTime": dateTime.toIso8601String(),
        "name": name,
        "blok": blok,
        "penghuni":penghuni
      };
}