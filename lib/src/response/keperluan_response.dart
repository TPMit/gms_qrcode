class KeperluanResponse {
  bool? success;
  List<DataKeperluan>? dataKeperluan;

  KeperluanResponse({this.success, this.dataKeperluan});

  KeperluanResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data_keperluan'] != null) {
      dataKeperluan = <DataKeperluan>[];
      json['data_keperluan'].forEach((v) {
        dataKeperluan!.add(new DataKeperluan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.dataKeperluan != null) {
      data['data_keperluan'] =
          this.dataKeperluan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataKeperluan {
  String? idPerlu;
  String? perlu;

  DataKeperluan({this.idPerlu, this.perlu});

  DataKeperluan.fromJson(Map<String, dynamic> json) {
    idPerlu = json['id_perlu'];
    perlu = json['perlu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_perlu'] = this.idPerlu;
    data['perlu'] = this.perlu;
    return data;
  }
}
