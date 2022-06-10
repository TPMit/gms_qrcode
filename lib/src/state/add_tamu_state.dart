import '../model/add_tamu_model.dart';
import '../response/penghuni_response.dart';

abstract class AddTamuState {
  void refreshData(AddTamuModel addTamuModel);
  void refreshLoading(bool isLoading);
  void refreshDataRumah(PenghuniResponse penghuniResponse);
  void onSuccess(String success);
  void onError(String error);
}
