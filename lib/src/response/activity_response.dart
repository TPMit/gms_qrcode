class ActivityResponse {
  bool? status;
  List<DataActivity>? dataActivity;

  ActivityResponse({this.status, this.dataActivity});

  ActivityResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data_activity'] != null) {
      dataActivity = <DataActivity>[];
      json['data_activity'].forEach((v) {
        dataActivity!.add(new DataActivity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.dataActivity != null) {
      data['data_activity'] =
          this.dataActivity!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataActivity {
  String? activityid;
  String? name;
  String? activity;
  String? dateTime;
  String? images;

  DataActivity(
      {this.activityid, this.name, this.activity, this.dateTime, this.images});

  DataActivity.fromJson(Map<String, dynamic> json) {
    activityid = json['activityid'];
    name = json['name'];
    activity = json['activity'];
    dateTime = json['date_time'];
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityid'] = this.activityid;
    data['name'] = this.name;
    data['activity'] = this.activity;
    data['date_time'] = this.dateTime;
    data['images'] = this.images;
    return data;
  }
}
