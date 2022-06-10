// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gms_mobile/src/model/absen_model.dart';

import '../state/absen_state.dart';
import 'package:location/location.dart';

abstract class AbsenPresenterAbstract {
  set view(AbsenState view) {}
  void checkKondisi(BuildContext context, String hasilQr) {}
  void checkKondisiOut(BuildContext context, String hasilQr, String attrId) {}
  void postCheckPoint(String nik, String tagId, String latitude, String longitude) {}
  void getUserLocation(BuildContext context){}
  void updateAbsen(String idattr) {}
}

class AbsenPresenter implements AbsenPresenterAbstract {
  final AbsenModel _absenModel = AbsenModel();
  late AbsenState _absenState;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  
  
  @override
  set view(AbsenState view) {
    _absenState =view;
    _absenState.refreshData(_absenModel);
  }

  @override
  void checkKondisi(BuildContext context, String hasilQr) {
    _absenModel.hasilQr = hasilQr;
    _absenState.refreshData(_absenModel);
    _absenState.showstatusKondisi(context);
  }

  @override
  void checkKondisiOut(BuildContext context, String hasilQr, String attrId) {
    print(attrId);
    _absenModel.attrId = attrId;
    _absenModel.hasilQr = hasilQr;
    _absenState.refreshData(_absenModel);
    _absenState.showstatusKondisi(context);
  }

  @override
  void postCheckPoint(
      String nik, String tagId, String latitude, String longitude) {
    print(nik);
    print(tagId);
    print(latitude);
    print(longitude);
  }

  @override
  Future<void> getUserLocation(BuildContext context) async {
    _absenModel.isloading = true;
    _absenState.refreshData(_absenModel);
    
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
      _absenModel.latitude = _locationData.latitude;
      _absenModel.longitude = _locationData.longitude;
      _absenModel.isloading = false;
      _absenModel.location = true;
      _absenState.refreshData(_absenModel);
      _absenState.onSuccess("yey, Berhasil :D");
      _absenState.showstatusKondisi(context);
    // setState(() {
    //   _userLocation = _locationData;
    // });
  }

  @override
  void updateAbsen(String idattr) {
    _absenModel.isloading = true;
    _absenState.refreshData(_absenModel);

  }

  
}