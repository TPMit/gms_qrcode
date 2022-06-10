import 'package:flutter/material.dart';

class Patrol {
  String idQrcode;
  String tagid;
  String idSite;
  String label;
  String lokasi;
  String images;
  String latitudeLongitude;
  String status;
  Patrol(
      {
    required this.idQrcode,
    required this.tagid,
    required this.idSite,
    required this.label,
    required this.lokasi,
    required this.images,
    required this.latitudeLongitude,
    required this.status,
  });
}

class PatrolAwal {
  String idQrcode;
  String currentdatetime;
  String tagid;
  String idSite;
  String label;
  String note;
  String lokasi;
  String images;
  String latitudeLongitude;
  String status;
  String username;
  String updatedAt;
  PatrolAwal({
    required this.idQrcode,
    required this.currentdatetime,
    required this.tagid,
    required this.idSite,
    required this.label,
    required this.note,
    required this.lokasi,
    required this.images,
    required this.latitudeLongitude,
    required this.status,
    required this.username,
    required this.updatedAt,
  });
}

class PatrolModel {
  bool isErrorUsername = false;
  bool isErrorEmail = false;
  bool isloading = false;
  bool isSuccess = false;
  int idCheckpoint = 0;
  String usernameError = "";
  String emailError = "";
  String hasilQr = "";
  String idTags = "";
  late int isKondusif;
  String desc = "";
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  List<Patrol> patrol = <Patrol>[];
  List<PatrolAwal> patrolAwal = <PatrolAwal>[];
}
