import 'package:flutter/material.dart';


class Tamu {
  String id;
  String noVisitor;
  String tanggal;
  String jam;
  String idPenghuni;
  String keteranganPerlu;
  String images;
  String idUser;
  String name;
  String dateTime;
  String blok;
  String penghuni;
  String status;
  Tamu({
    required this.id,
    required this.noVisitor,
    required this.tanggal,
    required this.jam,
    required this.idPenghuni,
    required this.keteranganPerlu,
    required this.images,
    required this.idUser,
    required this.name,
    required this.dateTime,
    required this.blok,
    required this.penghuni,
    required this.status
  });
}

class TamuModel {
  bool isErrorUsername = false;
  bool isErrorEmail = false;
  bool isloading = false;
  bool isSuccess = false;
  String usernameError = "";
  String emailError = "";
  String hasilQr = "";
  late int isKondusif;
  String desc = "";
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController sekolahController = TextEditingController();
  List<Tamu> tamunya = <Tamu>[];
}