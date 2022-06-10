
import '../model/tamu_model.dart';
import '../resources/activityApi.dart';
import '../state/tamu_state.dart';

abstract class TamuPresenterAbstract {
  set view(TamuState view) {}
  void getData(String param) {}
}

class TamuPresenter implements TamuPresenterAbstract {
  final TamuModel _TamuModel = TamuModel();
  late TamuState _TamuState;
  final ActivityServices _activityServices = ActivityServices();

  @override
  set view(TamuState view) {
    _TamuState = view;
    _TamuState.refreshData(_TamuModel);
  }

  @override
  void getData(String param) {
    print('mulaiii ambil data tamu');
    _TamuModel.isloading = true;
    _TamuState.refreshData(_TamuModel);
    _activityServices.getDataTamu(param).then((value) {
      value.dataVisitor!.forEach((element) {
        _TamuModel.tamunya.add(Tamu(
          blok: element.blok!,
          dateTime: element.tanggal.toString(),
          id: element.idTamu.toString(),
          idPenghuni: element.idPenghuni.toString(),
          idUser: element.idUser.toString(),
          images: element.images.toString(),
          jam: element.jam.toString(),
          keteranganPerlu: element.keteranganPerlu.toString(),
          name: element.nama.toString(),
          noVisitor: element.tamu.toString(),
          penghuni: element.penghuni.toString(),
          tanggal: element.tanggal.toString(),
          status: element.status.toString()
        ));
      });
      _TamuModel.isloading = false;
      _TamuState.refreshData(_TamuModel);
    }).catchError((error) {
        print(error);
      _TamuState.onError(error);
      _TamuModel.isloading = false;
      _TamuState.refreshData(_TamuModel);
    });
  }
}
