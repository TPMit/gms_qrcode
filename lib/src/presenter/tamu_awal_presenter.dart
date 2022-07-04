
import '../model/tamu_model.dart';
import '../resources/activityApi.dart';
import '../state/tamu_state.dart';

abstract class TamuPresenterAbstract {
  set view(TamuState view) {}
  void getData(String param) {}
}

class TamuPresenter implements TamuPresenterAbstract {
  final TamuModel _tamuModel = TamuModel();
  late TamuState _tamuState;
  final ActivityServices _activityServices = ActivityServices();

  @override
  set view(TamuState view) {
    _tamuState = view;
    _tamuState.refreshData(_tamuModel);
  }

  @override
  void getData(String param) {
    print('mulaiii ambil data tamu');
    _tamuModel.isloading = true;
    _tamuState.refreshData(_tamuModel);
    _activityServices.getDataTamu(param).then((value) {
      value.dataVisitor!.forEach((element) {
        _tamuModel.tamunya.add(Tamu(
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
      _tamuModel.isloading = false;
      _tamuState.refreshData(_tamuModel);
    }).catchError((error) {
        print(error);
      _tamuState.onError(error);
      _tamuModel.isloading = false;
      _tamuState.refreshData(_tamuModel);
    });
  }
}
