// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:gms_mobile/src/resources/tamuApi.dart';

import '../model/jumlah_pengunjung_model.dart';
import '../state/jumlah_pengunjung_state.dart';

abstract class JumlahPengunjungPresenterAbstract{
  set view(JumlahPengunjungState view){}
  void getData(String idSite) {}
}

class JumlahPengunjungPresenter implements JumlahPengunjungPresenterAbstract{
  final JumlahPengunjungModel _jumlahPengunjungModel = JumlahPengunjungModel();
  late JumlahPengunjungState _jumlahPengunjungState;
  final VisitorService _visitorService = VisitorService();

  @override
  set view(JumlahPengunjungState view) {
    _jumlahPengunjungState = view;
    _jumlahPengunjungState.refreshData(_jumlahPengunjungModel);
  }

  @override
  void getData(String idSite) {
    print('mulai get total');
    _jumlahPengunjungModel.isLoading = true;
    _jumlahPengunjungState.refreshData(_jumlahPengunjungModel);
    _visitorService.getData(idSite).then((value) {
      value.forEach((element) { 
        _jumlahPengunjungModel.rasioGrade.add(JumlahPengunjung(
          total: element.total
        ));
      });
      _jumlahPengunjungModel.isLoading = false;
      _jumlahPengunjungState.refreshData(_jumlahPengunjungModel);
    });
  }

  
}