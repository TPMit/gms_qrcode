import 'package:flutter/material.dart';

import '../model/absen_model.dart';

abstract class AbsenState {
  void refreshData(AbsenModel absenModel);
  void onSuccess(String success);
  void onError(String error);
  void showstatusKondisi(BuildContext context);
}
