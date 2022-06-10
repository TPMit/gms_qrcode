import 'package:flutter/cupertino.dart';

import '../model/tamu_model.dart';

abstract class TamuState {
  void refreshData(TamuModel tamuModel);
  void onSuccess(String success);
  void onError(String error);
  void showstatusKondisi(BuildContext context);
  void showDeskripsi(BuildContext context);
}
