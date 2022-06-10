class Activity {
  String name;
  String activity;
  String images;
  String dateTime;
  Activity({
    required this.name,
    required this.activity,
    required this.images,
    required this.dateTime
  });
}

class ActivityModel {
  bool isloading = false;
  bool isSuccess = false;
  bool location = false;
  String attrId = "";
  String hasilQr = "";
  double? latitude;
  double? longitude;
  String desc = "";

  List<Activity> activity = <Activity>[];
}
