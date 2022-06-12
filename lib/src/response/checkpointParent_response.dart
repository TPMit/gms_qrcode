class CheckpointParentResponse {
  bool? status;
  List<DataCheckpoints>? dataCheckpoints;

  CheckpointParentResponse({this.status, this.dataCheckpoints});

  CheckpointParentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data_checkpoints'] != null) {
      dataCheckpoints = <DataCheckpoints>[];
      json['data_checkpoints'].forEach((v) {
        dataCheckpoints!.add(new DataCheckpoints.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.dataCheckpoints != null) {
      data['data_checkpoints'] =
          this.dataCheckpoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataCheckpoints {
  String? id;
  String? idSite;
  String? idUser;
  String? tanggal;
  String? status;
  String? createdAt;
  String? username;

  DataCheckpoints(
      {this.id,
      this.idSite,
      this.idUser,
      this.tanggal,
      this.status,
      this.createdAt,
      this.username
      });

  DataCheckpoints.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idSite = json['id_site'];
    idUser = json['id_user'];
    tanggal = json['tanggal'];
    status = json['status'];
    createdAt = json['createdAt'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_site'] = this.idSite;
    data['id_user'] = this.idUser;
    data['tanggal'] = this.tanggal;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['username'] = this.username;
    return data;
  }
}
