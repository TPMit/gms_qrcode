class TamuResponse {
  bool? status;
  List<DataVisitor>? dataVisitor;

  TamuResponse({this.status, this.dataVisitor});

  TamuResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data_visitor'] != null) {
      dataVisitor = <DataVisitor>[];
      json['data_visitor'].forEach((v) {
        dataVisitor!.add(new DataVisitor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.dataVisitor != null) {
      data['data_visitor'] = this.dataVisitor!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataVisitor {
  String? idTamu;
  String? noVisitor;
  String? tamu;
  String? tanggal;
  String? jam;
  String? datetimeOut;
  String? idPenghuni;
  String? idPerlu;
  String? keteranganPerlu;
  String? images;
  String? status;
  String? idSite;
  String? idUser;
  String? createdAt;
  String? updatedAt;
  String? nama;
  String? blok;
  String? penghuni;

  DataVisitor(
      {this.idTamu,
      this.noVisitor,
      this.tamu,
      this.tanggal,
      this.jam,
      this.datetimeOut,
      this.idPenghuni,
      this.idPerlu,
      this.keteranganPerlu,
      this.images,
      this.status,
      this.idSite,
      this.idUser,
      this.createdAt,
      this.updatedAt,
      this.nama,
      this.blok,
      this.penghuni});

  DataVisitor.fromJson(Map<String, dynamic> json) {
    idTamu = json['id_tamu'];
    noVisitor = json['no_visitor'];
    tamu = json['tamu'];
    tanggal = json['tanggal'];
    jam = json['jam'];
    datetimeOut = json['datetime_out'] == null ? '' : json['datetime_out'];
    idPenghuni = json['id_penghuni'];
    idPerlu = json['id_perlu'];
    keteranganPerlu = json['keterangan_perlu'];
    images = json['images'];
    status = json['status'];
    idSite = json['id_site'];
    idUser = json['id_user'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at']  == null ? '' : json['updated_at'];
    nama = json['nama'];
    blok = json['blok'];
    penghuni = json['penghuni'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_tamu'] = this.idTamu;
    data['no_visitor'] = this.noVisitor;
    data['tamu'] = this.tamu;
    data['tanggal'] = this.tanggal;
    data['jam'] = this.jam;
    data['datetime_out'] = this.datetimeOut;
    data['id_penghuni'] = this.idPenghuni;
    data['id_perlu'] = this.idPerlu;
    data['keterangan_perlu'] = this.keteranganPerlu;
    data['images'] = this.images;
    data['status'] = this.status;
    data['id_site'] = this.idSite;
    data['id_user'] = this.idUser;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['nama'] = this.nama;
    data['blok'] = this.blok;
    data['penghuni'] = this.penghuni;
    return data;
  }
}
