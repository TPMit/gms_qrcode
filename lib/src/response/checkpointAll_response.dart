class CheckpointAllResponse {
  bool? success;
  List<DataCheckpoint>? dataCheckpoint;

  CheckpointAllResponse({this.success, this.dataCheckpoint});

  CheckpointAllResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data_checkpoint'] != null) {
      dataCheckpoint = <DataCheckpoint>[];
      json['data_checkpoint'].forEach((v) {
        dataCheckpoint!.add(new DataCheckpoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.dataCheckpoint != null) {
      data['data_checkpoint'] =
          this.dataCheckpoint!.map((v) => v.toJson()).toList();
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
  String? tagidUser;
  String? image;
  String? tanggal;
  String? isclear;
  String? note;
  String? latitudeLongitudeTag;
  String? latitudeLongitude;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? username;

  DataCheckpoint(
      {this.idCheck,
      this.idCheckpoint,
      this.currentdatetime,
      this.idUser,
      this.idSite,
      this.label,
      this.lokasi,
      this.tagid,
      this.tagidUser,
      this.image,
      this.tanggal,
      this.isclear,
      this.note,
      this.latitudeLongitudeTag,
      this.latitudeLongitude,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.username});

  DataCheckpoint.fromJson(Map<String, dynamic> json) {
    idCheck = json['id_check'];
    idCheckpoint = json['id_checkpoint'];
    currentdatetime = json['currentdatetime'];
    idUser = json['id_user'];
    idSite = json['id_site'];
    label = json['label'];
    lokasi = json['lokasi'];
    tagid = json['tagid'];
    tagidUser = json['tagid_user'];
    image = json['image'] == null ? '' : json['image'];
    tanggal = json['tanggal'];
    isclear = json['isclear'];
    note = json['note'] == null ? '' : json['note'];
    latitudeLongitudeTag = json['latitude_longitude_tag'];
    latitudeLongitude = json['latitude_longitude'] == null ? '' : json['latitude_longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_check'] = this.idCheck;
    data['id_checkpoint'] = this.idCheckpoint;
    data['currentdatetime'] = this.currentdatetime;
    data['id_user'] = this.idUser;
    data['id_site'] = this.idSite;
    data['label'] = this.label;
    data['lokasi'] = this.lokasi;
    data['tagid'] = this.tagid;
    data['tagid_user'] = this.tagidUser;
    data['image'] = this.image == null;
    data['tanggal'] = this.tanggal;
    data['isclear'] = this.isclear;
    data['note'] = this.note;
    data['latitude_longitude_tag'] = this.latitudeLongitudeTag;
    data['latitude_longitude'] = this.latitudeLongitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['username'] = this.username;
    return data;
  }
}
