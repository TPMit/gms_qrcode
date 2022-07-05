class QrcodeTagResponse {
  bool? success;
  List<DataCheckpoint>? dataCheckpoint;

  QrcodeTagResponse({this.success, this.dataCheckpoint});

  QrcodeTagResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data_checkpoint'] != null) {
      dataCheckpoint = <DataCheckpoint>[];
      json['data_checkpoint'].forEach((v) {
        dataCheckpoint!.add(DataCheckpoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (dataCheckpoint != null) {
      data['data_checkpoint'] =
          dataCheckpoint!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataCheckpoint {
  String? idCheck;
  String? idCheckpoint;
  String? currentdatetime;
  String? idUser;
  String? idSite;
  String? label;
  String? lokasi;
  String? tagid;
  String? image;
  String? tanggal;
  String? time;
  String? isclear;
  String? note;
  String? latitudeLongitudeTag;
  String? latitudeLongitude;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? statusLokasi;
  String? lokasiDb;

  DataCheckpoint(
      {this.idCheck,
      this.idCheckpoint,
      this.currentdatetime,
      this.idUser,
      this.idSite,
      this.label,
      this.lokasi,
      this.tagid,
      this.image,
      this.tanggal,
      this.time,
      this.isclear,
      this.note,
      this.latitudeLongitudeTag,
      this.latitudeLongitude,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.statusLokasi,
      this.lokasiDb});

  DataCheckpoint.fromJson(Map<String, dynamic> json) {
    idCheck = json['id_check'];
    idCheckpoint = json['id_checkpoint'];
    currentdatetime = json['currentdatetime'];
    idUser = json['id_user'];
    idSite = json['id_site'];
    label = json['label'];
    lokasi = json['lokasi'];
    tagid = json['tagid'];
    image = json['image'] == null ? 'default.jpg' : json['image'];
    tanggal = json['tanggal'];
    time = json['time'] == null ? '00:00' : json['time'];
    isclear = json['isclear'];
    note = json['note'];
    latitudeLongitudeTag = json['latitude_longitude_tag'];
    latitudeLongitude = json['latitude_longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    statusLokasi = json['status_lokasi'];
    lokasiDb = json['lokasiDb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_check'] = idCheck;
    data['id_checkpoint'] = idCheckpoint;
    data['currentdatetime'] = currentdatetime;
    data['id_user'] = idUser;
    data['id_site'] = idSite;
    data['label'] = label;
    data['lokasi'] = lokasi;
    data['tagid'] = tagid;
    data['image'] = image;
    data['tanggal'] = tanggal;
    data['time'] = time;
    data['isclear'] = isclear;
    data['note'] = note;
    data['latitude_longitude_tag'] = latitudeLongitudeTag;
    data['latitude_longitude'] = latitudeLongitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['status_lokasi'] = statusLokasi;
    data['lokasiDb'] = lokasiDb;
    return data;
  }
}
