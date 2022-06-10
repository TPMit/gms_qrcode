import 'package:flutter/material.dart';

import '../model/patrol_model.dart';

abstract class PatrolState {
  void refreshData(PatrolModel patrolModel);
  void onSuccess(String success);
  void onSuccessUnCondusif(String success);
  void onError(String error);
  void showstatusKondisi(BuildContext context);
  void showDeskripsi(BuildContext context);
  void scan(String idTag);
}
