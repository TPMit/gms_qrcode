// // ignore_for_file: avoid_print

// import 'package:flutter/cupertino.dart';
// import 'package:gms_mobile/src/model/tamu_model.dart';

// import '../resources/checkpointApi.dart';
// import '../state/tamu_state.dart';

// abstract class TamuPresenterAbstract {
//   set view(TamuState view) {}
//   void checkKondisi(BuildContext context, String hasilQr) {}
//   void checkDeskripsi(BuildContext context, int kondusif) {}
//   void postCheckPoint(String idCheck, String nik, String tagId, int isKondusif, String desc) {}
// }

// class TamuPresenter implements TamuPresenterAbstract {
//   final TamuModel _tamuModel = TamuModel();
//   late TamuState _tamuState;

//   @override
//   set view(TamuState view) {
//     _tamuState = view;
//     _tamuState.refreshData(_tamuModel);
//   }

//   @override
//   void checkKondisi(BuildContext context, String hasilQr) {
//     _tamuModel.hasilQr = hasilQr;
//     _tamuState.refreshData(_tamuModel);
//     _tamuState.showstatusKondisi(context);
//   }

//   @override
//   void checkDeskripsi(BuildContext context, int kondusif) {
//     _tamuModel.isKondusif = kondusif;
//     _tamuState.showDeskripsi(context);
    
//   }

//   @override
//   void postCheckPoint(String idCheck, String nik, String tagId, int isKondusif, String desc) {
//     print('mulai save');
//     _tamuModel.isloading = true;
//     _tamuState.refreshData(_tamuModel);
//     ListCheckPointService.postCheckPoint(idCheck, tagId, isKondusif, desc).then((value) async {
//       print(value);
//       _tamuModel.isloading = false;
//       _tamuState.refreshData(_tamuModel);
//       _tamuState.onSuccess("Daftar tamu ditambahkan");
//     }).catchError((onError) {
//       print(onError);
//       _tamuModel.isloading = false;
//       _tamuState.refreshData(_tamuModel);
//       _tamuState.onError(onError);
//     });
//   }
  
// }