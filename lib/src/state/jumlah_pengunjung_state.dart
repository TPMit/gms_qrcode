
import '../model/jumlah_pengunjung_model.dart';

abstract class JumlahPengunjungState {
  void refreshData(JumlahPengunjungModel jumlahPengunjungModel);
  void onSuccess(String success);
  void onError(String error);
}
