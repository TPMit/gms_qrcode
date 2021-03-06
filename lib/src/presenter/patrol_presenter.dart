// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gms_mobile/src/model/patrol_model.dart';

import '../resources/checkpointApi.dart';
import '../state/patrol_state.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

abstract class PatrolPresenterAbstract {
  set view(PatrolState view) {}
  void checkKondisi(BuildContext context, String idTag, String hasilQr,String lokasiDb) {}
  void checkDeskripsi(BuildContext context, int kondusif) {}
  void postCheckPoint(String idCheck, String nik, String tagId, int isKondusif, String desc, String lokasi) {}
  void postCheckPointUnCondusif(String idCheck, String nik, String tagId, int isKondusif, String desc, String lokasi) {}
  void getCheckpointTag(String time, idSite,int idCheckpoint){}
  void newCheckpoint(String idSite, String idUser){}
  void checkEmpty(String tagId, String lokasiDb){}
  void getData(){}
  void getUserLocation(BuildContext context, String lokasiDb){}
  void getDetailPatrol(BuildContext context, String idCheck){}
  void checkJam(String time, String idQrcode, String idUser, String lokasiDb){}
}

class PatrolPresenter implements PatrolPresenterAbstract {
  final PatrolModel _patrolModel = PatrolModel();
  late PatrolState _patrolState;
  ListCheckPointService _listCheckPointService = ListCheckPointService();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  bool positionStreamStarted = false;
  late bool serviceEnabled;
  late LocationPermission permission;
  // late bool _serviceEnabled;
  // late PermissionStatus _permissionGranted;

  @override
  set view(PatrolState view) {
    _patrolState = view;
    _patrolState.refreshData(_patrolModel);
  }

  @override
  void getCheckpointTag(String time, idSite,int idCheckpoint) {
    print(idCheckpoint);
    _patrolModel.patrol.clear();
    _patrolModel.isloading = true;
    _patrolState.refreshData(_patrolModel);
    ListCheckPointService.getHistoryCheckPoints(idCheckpoint.toString()).then((value) {
      value.dataCheckpoint?.forEach((element) { 
        _patrolModel.patrol.add(Patrol(
          idQrcode: element.idCheck.toString(),
          idUser: element.idUser.toString(),
          idSite: element.idSite.toString(),
          label: element.label.toString(),
          lokasi: element.lokasi.toString(),
          latitudeLongitude: element.latitudeLongitude.toString(),
          images: element.image.toString(),
          status: element.status.toString(),
          tagid: element.tagid.toString(),
          statusLokasi: element.statusLokasi.toString(),
          lokasiUrutan: element.lokasiUrutan.toString(),
          jam: element.createdAt.toString(),
          lokasiDb: element.lokasiDb.toString() + "${Random().nextInt(999) + 100}",
        ));
       });
       _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
    }).catchError((err) {
      print(err.toString());
      _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.onError(err.toString());
    });
  }

  @override
  void checkKondisi(BuildContext context, String idTag, String hasilQr, lokasiDb) {
    _patrolModel.hasilQr = hasilQr;
    _patrolModel.idTags = idTag;
    _patrolState.refreshData(_patrolModel);
    _patrolState.showStatusLokasi(context, lokasiDb);
  }

  @override
  void checkDeskripsi(BuildContext context, int kondusif) {
    _patrolModel.isKondusif = kondusif;
    _patrolState.showDeskripsi(context);
  }

  @override
  void postCheckPoint(String idCheck, String nik, String tagId, int isKondusif, String desc, String lokasi) {
    print('mulai Update');
    print(idCheck);
    print(tagId);
    print(isKondusif);
    print(desc);
    print(lokasi);
    _patrolModel.isloading = true;
    _patrolState.refreshData(_patrolModel);
    ListCheckPointService.postCheckPoint(idCheck, tagId, isKondusif, desc, lokasi)
        .then((value) async {
      print(value);
      _patrolModel.isloading = false;
      _patrolModel.latitude = null;
      _patrolModel.longitude = null;
      _patrolModel.location = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.onSuccess("Update Patrol berhasil");
    }).catchError((onError) {
      print(onError);
      _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.onError(onError);
    });
  }

  @override
  void postCheckPointUnCondusif(String idCheck, String nik, String tagId, int isKondusif, String desc, String lokasi) {
    print('mulai save');
    print(idCheck);
    print(tagId);
    print(isKondusif);
    print(desc);
    _patrolModel.isloading = true;
    _patrolState.refreshData(_patrolModel);
    ListCheckPointService.postCheckPoint(idCheck, tagId, isKondusif, desc, lokasi)
        .then((value) async {
      print(value);
      _patrolModel.latitude = null;
      _patrolModel.longitude = null;
      _patrolModel.location = false;
      _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.onSuccessUnCondusif("Daftar Patrol ditambahkan");
    }).catchError((onError) {
      print(onError);
      _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.onError(onError);
    });
  }

  @override
  void checkEmpty(String tagId, String lokasiDb) {
    print('==id=='+tagId);
    _patrolModel.isloading = true;
    _patrolState.refreshData(_patrolModel);
    ListCheckPointService.checkEmpty(tagId).then((value) async{
      print('==='+value.toString());
      if(value == 1){
        _patrolState.onError("data sudah ada");
        _patrolModel.isloading = false;
        _patrolState.refreshData(_patrolModel);
      }else{
        print('mulai scan 1');
        _patrolState.scan(tagId, lokasiDb);
        _patrolModel.isloading = false;
        _patrolState.refreshData(_patrolModel);
      }
    }).catchError((onError){
      print(onError);
    _patrolModel.isloading = false;
    _patrolState.refreshData(_patrolModel);
    });
  }

  @override
  void newCheckpoint(String idUser, String idSite) {
    print('go newcheckpoint');
    print(idUser);
    print(idSite);
    _patrolModel.isloading = true;
    _patrolState.refreshData(_patrolModel);
    ListCheckPointService.newCheckpoint(idUser,idSite).then((value) async {
      if(value == 0) {
        _patrolState.onError("terjadi kesalahan, hubungi admin");
        _patrolModel.isloading = false;
        _patrolState.refreshData(_patrolModel);
      }else{
        _patrolModel.idCheckpoint = value;
        _patrolState.refreshData(_patrolModel);
        print('go get data all');
        _listCheckPointService.getDataCheckPointParent().then((values) {
          values.dataCheckpoints!.forEach((element) {
            _patrolModel.patrolAwal.add(PatrolAwal(
              idQrcode: element.id.toString(),
              idSite: element.idSite.toString(),
              currentdatetime: element.createdAt.toString(),
              username: element.username.toString(),
              tanggal: element.tanggal.toString(),
              label: 'Checkpoint hari ini',
            ));
          });
          _patrolModel.isloading = false;
          _patrolState.refreshData(_patrolModel);
        }).catchError((err) {
          print(err.toString());
          _patrolModel.isloading = false;
          _patrolState.refreshData(_patrolModel);
          _patrolState.onError(err.toString());
        });
      }
    });
  }

    @override
  Future<void> getUserLocation(BuildContext context, String lokasiDb) async {
    _patrolModel.isloading = true;
    _patrolState.refreshData(_patrolModel);
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _patrolState.onError('izin lokasi ditolak');
        _patrolModel.isloading = false;
        _patrolState.refreshData(_patrolModel);
        // return Future.error('Location permissions are denied');
      }
    }else{
      final _locationData = await _geolocatorPlatform.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      );
    _patrolModel.latitude = _locationData.latitude;
    _patrolModel.longitude = _locationData.longitude;
    _patrolModel.isloading = false;
    _patrolModel.location = true;
    _patrolState.refreshData(_patrolModel);
    _patrolState.onSuccess("yey, Berhasil :D");
    _patrolState.showStatusLokasi(context, lokasiDb);
    }
    // setState(() {
    //   _userLocation = _locationData;
    // });
  }


  @override
  void getData() {
    _patrolModel.isloading = true;
    _patrolState.refreshData(_patrolModel);
    _listCheckPointService.getDataCheckPointParent().then((values) {
      values.dataCheckpoints!.forEach((element) {
        _patrolModel.patrolAwal.add(PatrolAwal(
          idQrcode: element.id.toString(),
          idSite: element.idSite.toString(),
          currentdatetime: element.createdAt.toString(),
          username: element.username.toString(),
          tanggal: element.tanggal.toString(),
          label: 'Checkpoint hari ini',
          ));
       });
    _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
    }).catchError((err) {
      print(err.toString());
      _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.onError(err.toString());
    });
  }

  @override
  void getDetailPatrol(BuildContext context, String idCheck) {
    _patrolModel.isloading = true;
    _patrolState.refreshData(_patrolModel);
    ListCheckPointService.getHistoryCheckPoints(idCheck)
        .then((value) {
      value.dataCheckpoint?.forEach((element) {
        _patrolModel.patrol.add(Patrol(
          idQrcode: element.idCheck.toString(),
          idUser: element.idUser.toString(),
          idSite: element.idSite.toString(),
          label: element.label.toString(),
          lokasi: element.lokasi.toString(),
          latitudeLongitude: element.latitudeLongitude.toString(),
          images: element.image.toString(),
          status: element.status.toString(),
          tagid: element.tagid.toString(),
          statusLokasi: element.statusLokasi.toString(),
          lokasiUrutan: element.lokasiUrutan.toString(),
          jam: element.createdAt.toString(),
          lokasiDb:
              element.lokasiDb.toString() + "${Random().nextInt(999) + 100}",
        ));
      });
      _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.showDetailPatrol(context, idCheck);
    }).catchError((err) {
      print(err.toString());
      _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.onError(err.toString());
    });
  }

  @override
  void checkJam(String time, String idQrcode, idUser, String lokasiDb) {
    _patrolModel.isloading = true;
    _patrolState.refreshData(_patrolModel);
    // print(time);
    // print('======');
    // print(idUser);
    _listCheckPointService.checkTime(time, idUser).then((value) {
      _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.scan(idQrcode, lokasiDb);
    }).onError((error, stackTrace) {
      _patrolModel.isloading = false;
      _patrolState.refreshData(_patrolModel);
      _patrolState.onError(error.toString());
    });
  }
}
