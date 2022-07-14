import 'package:flutter/material.dart';

class Patrol {
  String idQrcode;
  String idUser;
  String tagid;
  String idSite;
  String label;
  String lokasi;
  String images;
  String latitudeLongitude;
  String status;
  String statusLokasi;
  String lokasiUrutan;
  String jam;
  String lokasiDb;
  Patrol(
      {
    required this.idQrcode,
    required this.idUser,
    required this.tagid,
    required this.idSite,
    required this.label,
    required this.lokasi,
    required this.images,
    required this.latitudeLongitude,
    required this.status,
    required this.statusLokasi,
    required this.lokasiUrutan,
    required this.jam,
    required this.lokasiDb,
  });
}

class PatrolAwal {
  String idQrcode;
  String idSite;
  String currentdatetime;
  String username;
  String tanggal;
  String label;
  PatrolAwal({
    required this.idQrcode,
    required this.idSite,
    required this.currentdatetime,
    required this.username,
    required this.tanggal,
    required this.label,
    
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
  bool location = false;
  double? latitude;
  double? longitude;
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  List<Patrol> patrol = <Patrol>[];
  List<PatrolAwal> patrolAwal = <PatrolAwal>[];
}
