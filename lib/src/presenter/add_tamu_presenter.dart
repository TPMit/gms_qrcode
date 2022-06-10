// import 'package:security_tpm/src/response/penghuni_master_response.dart';
// ignore_for_file: avoid_print

import 'package:gms_mobile/src/state/add_tamu_state.dart';

import '../model/add_tamu_model.dart';
// import '../model/list_penghuni.dart';
import '../resources/absenApi.dart';

abstract class AddTamuPresenterAbstract {
  set view(AddTamuState view) {}
  void getData(String param) {}
  void getDataPenghuninya(String param) {}
  void getDataKeperluan(String param) {}
}

class AddTamuPresenter implements AddTamuPresenterAbstract{
  final AddTamuModel _addTamuModel = AddTamuModel();
  late AddTamuState _addTamuState;
  final ListAbsenService _listAbsenService = ListAbsenService();


  @override
  set view(AddTamuState view) { 
    _addTamuState = view;
    _addTamuState.refreshData(_addTamuModel);
  }

  @override
  void getData(String param) {
    print('mulaiii');
    _addTamuModel.isLoading = true;
    _addTamuState.refreshData(_addTamuModel);
    print(_addTamuModel.isLoading);
    _listAbsenService.getMemberPenghuni(param).then((value) {
        _addTamuModel.penghuninya = value;
        _addTamuModel.isLoading = false;
        _addTamuState.refreshData(_addTamuModel);
    }).catchError((error){
      print(error);
      _addTamuState.onError(error);
      _addTamuModel.isLoading = false;
      _addTamuState.refreshData(_addTamuModel);
    });
  }

  @override
  void getDataPenghuninya(String param) {
    print('mulaiii');
    _addTamuState.refreshLoading(true);
    print(_addTamuModel.isLoading);
    _listAbsenService.getMemberPenghuni(param).then((value) {
      _addTamuModel.penghuninya = value;
      _addTamuState.refreshLoading(false);
      _addTamuState.refreshDataRumah(_addTamuModel.penghuninya);
    }).catchError((error) {
      print(error);
      _addTamuState.onError('tidak ditemukan');
      _addTamuModel.isLoading = false;
      _addTamuState.refreshData(_addTamuModel);
    });
  }

  @override
  void getDataKeperluan(String param) {
    print('mulaiii get keperluan');
    _addTamuModel.isLoading = true;
    _addTamuState.refreshData(_addTamuModel);
    print(_addTamuModel.isLoading);
    _listAbsenService.getKeperluan(param).then((value) {
      _addTamuModel.keperluannya = value;
      _addTamuModel.isLoading = false;
      _addTamuState.refreshData(_addTamuModel);
    }).catchError((err){
      print(err);
      _addTamuState.onError(err);
      _addTamuModel.isLoading = false;
      _addTamuState.refreshData(_addTamuModel);
    });
  }

}