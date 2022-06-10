import 'package:flutter/material.dart';
import 'package:gms_mobile/src/model/list_penghuni.dart';
import 'package:gms_mobile/src/response/keperluan_response.dart';

import '../response/penghuni_response.dart';

class AddTamuModel{
  bool isLoading = false;
  bool isSuccess = false;
  String idPenghuni = '';
  String idKeperluan = '';
  TextEditingController tanggalController = TextEditingController();
  TextEditingController waktuController = TextEditingController();
  TextEditingController rumahController = TextEditingController();
  TextEditingController keperluanController = TextEditingController();
  TextEditingController keteranganPerluController = TextEditingController();
  List<ListPenghuniModel> listPenghuni = <ListPenghuniModel>[];
  KeperluanResponse keperluannya = KeperluanResponse();
  PenghuniResponse penghuninya = PenghuniResponse();
}