// import 'fragment/absen_add.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gms_mobile/screen/fragment/loading.dart';
import 'package:gms_mobile/src/model/absen_model.dart';
import 'package:gms_mobile/src/presenter/absen_presenter.dart';
import 'package:gms_mobile/src/state/absen_state.dart';

import '../src/model/list_absen_model.dart';
import '../src/resources/absenApi.dart';
import 'fragment/component/clipath.dart';
import 'fragment/component/customdialogwithcontainer.dart';
import 'fragment/component/dropdown_absensi.dart';
import 'fragment/component/ligh_colors.dart';
import 'fragment/component/roundedbutton.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:barcode_scan2/barcode_scan2.dart';
import '../../src/resources/session.dart';

class AbsenScreen extends StatefulWidget {
  const AbsenScreen({Key? key}) : super(key: key);

  @override
  _AbsenScreenState createState() => _AbsenScreenState();
}


class _AbsenScreenState extends State<AbsenScreen> implements AbsenState {
  String barcode = "";
  late String idUser = "";
  ScanResult? scanResult;
  
  late int selectedAbsensi = 1;
  bool showInputHour = false;
  String? hour;

  DateTime now = DateTime.now();

  late AbsenModel _absenModel;
  late AbsenPresenter _absenPresenter;

  _AbsenScreenState() {
    _absenPresenter = AbsenPresenter();
  }

  @override
  void initState() {
    super.initState();
    Session.getId().then((value) {
      setState(() {
        idUser = value.toString();
      });
    });
    _absenPresenter.view = this;
    print('=== tampilan absen ===');
  }

  @override
  void dispose() {
    super.dispose();
    _absenModel.latitude = null;
    _absenModel.longitude = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _absenModel.isloading? const Loading() 
        : Stack(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                padding: const EdgeInsets.only(bottom: 0),
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: TClipper(),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 260.0,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                          colors: [
                            Color(0xff25509e),
                            LightColors.kDarkYellow,
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 0.0),
                        )),
                      ),
                    ),
                    Positioned(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Ionicons.arrow_back,
                              color: Colors.white,
                            ),
                            iconSize: 24,
                            onPressed: () {
                              Navigator.pushNamed(context, "/home");
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Ionicons.add,
                              color: Colors.white,
                            ),
                            iconSize: 34,
                            onPressed: () {
                              _scan();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const AddAbsenScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      top: 60,
                      left: 40,
                      child: Text(
                        'Absensi Hari ini',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  // padding: EdgeInsets.all(20),
                  margin: const EdgeInsets.all(15),
                  child: FutureBuilder<List<ListAbsenModel>>(
                    future: ListAbsenService.get(
                        idUser.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('An error has occurred!',
                              style: TextStyle(color: Colors.black)),
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return AbsenList(listAbsen: snapshot.data!);
                      } else {
                        return const Center(
                          child: Text(
                            'Belum ada absensi!',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ));
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan();
      setState(() {
        scanResult = result;
      });
      print(scanResult!.rawContent.toString());
      if (scanResult!.rawContent.toString() != "") {
        _absenPresenter.checkKondisi(
            context, scanResult!.rawContent.toString());
      }
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }


  @override
  void onError(String error) {
    
  }

  @override
  void onSuccess(String success) {
    Navigator.pop(context);
    print(success);
  }

  @override
  void refreshData(AbsenModel absenModel) {
    setState(() {
      _absenModel = absenModel;
    });
  }

  @override
  void showstatusKondisi(BuildContext context) {
    showCupertinoModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        builder: (context) {
          return Material(
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(15),
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          "Detail Aktifitas",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("lokasi user harus sama dengan lokasi absen masuk"),
                              _absenModel.location
                                  ? Column(
                                    mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Wrap(
                                            children: [
                                              Text(
                                                  'Your latitude: ${_absenModel.latitude}'),
                                              const SizedBox(width: 10),
                                              Text(
                                                  'Your longtitude: ${_absenModel.longitude}'),
                                            ],
                                          ),
                                        ),
                                        RoundedButton(
                                          text: "Pilih Absen",
                                          press: () async {
                                            print(_absenModel.hasilQr.toString());
                                            setState(() {
                                              _absenModel.desc = "";
                                            });
                                            _absenPresenter.postCheckPoint(
                                                idUser,
                                                _absenModel.hasilQr,
                                                _absenModel.latitude.toString(),
                                                _absenModel.longitude
                                                    .toString(),
                                            );
                                                // _postAbsensi();
                                                Navigator.pop(context);
                                                showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CustomDialogContainer(
                                                        title: idUser,
                                                        child:
                                                            DropdownSelectAbsensi(
                                                                hasilQr: _absenModel.hasilQr,
                                                                idUser: idUser,
                                                                latitudeLongitude: _absenModel.latitude.toString() + ',' + _absenModel.longitude.toString(),
                                                                )));
                                          },
                                          color: Colors.green,
                                        )
                                    ],
                                  )
                                  : Column(
                                    mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                              vertical: 8),
                                        child: Text("lokasi belum dimasukan",style: TextStyle(fontSize: 10),),
                                      ),
                                      RoundedButton(
                                        text: "Ambil Lokasi",
                                        press: () {
                                          _absenPresenter.getUserLocation(context);
                                        },
                                        color: Colors.blue,
                                      ) 
                                                  
                                    ],
                                  ),
                                
                              // Image.network(
                              //     'https://gmsnv.mindotek.com/assets/imagesofgms/activities/' +
                              //         image)
                            ],
                          ),
                        )
                      ],
                    ),
                    
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class AbsenList extends StatelessWidget {
  const AbsenList({Key? key, required this.listAbsen}) : super(key: key);
  final List<ListAbsenModel> listAbsen;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listAbsen.length,
        itemBuilder: (context, index) {
          ListAbsenModel data = listAbsen[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Chip(
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: 8, horizontal: 0),
                      //     backgroundColor:
                      //         statusColor[int.parse(data.isin)],
                      //     label: const Text(
                      //       'Absen Masuk',
                      //       style: TextStyle(
                      //           fontSize: 10, color: Colors.white),
                      //     )),
                      Chip(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 0),
                          backgroundColor: Colors.grey,
                          label: Text(
                            data.thetime,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
