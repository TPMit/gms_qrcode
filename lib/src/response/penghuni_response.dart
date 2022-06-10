class PenghuniResponse {
  bool? success;
  List<DataPenghuni>? dataPenghuni;

  PenghuniResponse({this.success, this.dataPenghuni});

  PenghuniResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data_penghuni'] != null) {
      dataPenghuni = <DataPenghuni>[];
      json['data_penghuni'].forEach((v) {
        dataPenghuni!.add(new DataPenghuni.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.dataPenghuni != null) {
      data['data_penghuni'] =
          this.dataPenghuni!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataPenghuni {
  String? idPenghuni;
  String? blok;
  String? kategori;

  DataPenghuni({this.idPenghuni, this.blok, this.kategori});

  DataPenghuni.fromJson(Map<String, dynamic> json) {
    idPenghuni = json['id_penghuni'];
    blok = json['blok'];
    kategori = json['kategori'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_penghuni'] = this.idPenghuni;
    data['blok'] = this.blok;
    data['kategori'] = this.kategori;
    return data;
  }
}
