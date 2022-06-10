// import 'fragment/absen_add.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gms_mobile/screen/fragment/loading.dart';
import 'package:gms_mobile/src/model/absen_model.dart';
import 'package:gms_mobile/src/presenter/absen_presenter.dart';
import 'package:gms_mobile/src/state/absen_state.dart';

import '../src/model/list_absen_model.dart';
import '../src/resources/absenApi.dart';

// import 'package:get_storage/get_storage.dart';
// import '../helper/getStorage.dart' as constants;
import 'fragment/component/clipath.dart';
import 'fragment/component/ligh_colors.dart';
import 'fragment/component/roundedbutton.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:barcode_scan2/barcode_scan2.dart';
import '../../src/resources/session.dart';
import 'package:http/http.dart' as http;

class AbsenOutScreen extends StatefulWidget {
  const AbsenOutScreen({Key? key}) : super(key: key);

  @override
  _AbsenOutScreenState createState() => _AbsenOutScreenState();
}


class _AbsenOutScreenState extends State<AbsenOutScreen> implements AbsenState {
  String barcode = "";
  late int idUser = 0;
  ScanResult? scanResult;

  DateTime now = DateTime.now();

  late AbsenModel _absenModel;
  late AbsenPresenter _absenPresenter;

  _AbsenOutScreenState() {
    _absenPresenter = AbsenPresenter();
  }

  @override
  void initState() {
    super.initState();
    Session.getId().then((value) {
      setState(() {
        idUser = int.parse(value!);
      });
      print('===');
    });
    print(Session.getId());
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
        body: _absenModel.isloading
            ? const Loading()
            : Stack(
                children: [
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 245.0,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    // IconButton(
                                    //   icon: const Icon(
                                    //     Ionicons.add,
                                    //     color: Colors.white,
                                    //   ),
                                    //   iconSize: 34,
                                    //   onPressed: () {
                                    //     _scan();
                                    //     // Navigator.push(
                                    //     //     context,
                                    //     //     MaterialPageRoute(
                                    //     //         builder: (context) =>
                                    //     //             const AddAbsenOutScreen()));
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                              const Positioned(
                                top: 60,
                                left: 40,
                                child: Text(
                                  'Absensi Keluar',
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
                            margin: const EdgeInsets.all(10),
                            child: FutureBuilder<List<ListAbsenModel>>(
                              future: ListAbsenService.get(
                                  idUser.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text('An error has occurred!',
                                        style: TextStyle(color: Colors.black)),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data != null) {
                                      List statusColor = [
                                    Colors.blue,
                                    Colors.blue[600],
                                    Colors.orange[800],
                                    Colors.blueGrey[700],
                                    Colors.lime[800],
                                    Colors.yellow[900],
                                    Colors.lightBlue[200],
                                    Colors.red[300],
                                    Colors.blueGrey[400],
                                    Colors.indigo[300],
                                    Colors.cyan[600],
                                    Colors.red,
                                    Colors.cyan[900],
                                    Colors.blueGrey[600],
                                    Colors.blueGrey[900],
                                    Colors.teal[900],
                                    Colors.blueGrey,
                                    Colors.blueGrey,
                                    Colors.blueGrey
                                  ];
                                  return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        ListAbsenModel data = snapshot.data![index];
                                        return GestureDetector(
                                          onTap: () {
                                            if(data.isin == "1"){
                                              _scan(data.attid);
                                            }else{
                                              Fluttertoast.showToast(
                                                  msg: 'Upload gagal',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 2,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 15);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: Colors.white),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    data.name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  data.isin == "0"
                                                  ? Chip(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal: 0),
                                                          backgroundColor:
                                                              statusColor[
                                                                    8],
                                                          label: const Text(
                                                            'sudah Absen Pulang',
                                                            style: TextStyle(
                                                                    fontSize: 8,
                                                                    color: Colors
                                                                        .white),
                                                          ))
                                                  : Chip(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal: 0),
                                                          backgroundColor:
                                                              statusColor[
                                                                  2],
                                                          label: const Text(
                                                            'Baru Absen Masuk',
                                                            style: TextStyle(
                                                                    fontSize: 8,
                                                                    color: Colors
                                                                        .white),
                                                          )),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Chip(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal: 0),
                                                          backgroundColor:
                                                              Colors.grey,
                                                          label: Text(
                                                            data.thetime,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize: 8,
                                                                    color: Colors
                                                                        .black),
                                                          ))
                                                      
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  return const Center(
                                    child: Text(
                                      'Belum ada absensi!',
                                      style: TextStyle(color: Colors.white),
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

  Future<void> _scan(String idAttr) async {
    try {
      final result = await BarcodeScanner.scan();
      setState(() {
        scanResult = result;
      });
      print(scanResult!.rawContent.toString());
      if (scanResult!.rawContent.toString() != "") {
        _absenPresenter.checkKondisiOut(
            context, scanResult!.rawContent.toString(), idAttr);
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

  Future _postAbsensi() async {
    Map<String, dynamic> content = <String, dynamic>{};
    content['attrid'] = _absenModel.attrId;
    content['tagid_out'] = _absenModel.hasilQr;
    content['thetime_out'] = DateFormat('kk:mm').format(now);
    content['latitude_longitude_out'] = _absenModel.latitude.toString() + ', ' + _absenModel.longitude.toString();
    // content['id_site'] = GetStorage().read(constants.idSite);
    // content['nik'] = idUser.toString();
    // content['longitude_out'] = _absenModel.longitude.toString();
    // content['thedate'] = DateFormat('yyyy-MM-dd').format(now);
    var response = await http.post(
      Uri.https('gmsnv.mindotek.com', 'attendance/absenbydanru_out'),
      body: content,
    );
    if (response.statusCode == 200) {
      print('success');
      Navigator.pop(context);
      ListAbsenService.get(idUser.toString());
    } else {
      print('failed');
      Fluttertoast.showToast(
          msg: 'Upload gagal',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15);
    }
  }

  @override
  void onError(String error) {}

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
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  "lokasi user harus sama dengan lokasi absen masuk"),
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
                                          text: "Kumpulkan",
                                          press: () async {
                                            setState(() {
                                              _absenModel.desc = "";
                                            });
                                              print(_absenModel.attrId);
                                              print(idUser.toString());
                                              print(_absenModel.hasilQr);
                                              print(_absenModel.latitude.toString());
                                              print(_absenModel.longitude.toString());
                                            // _absenPresenter.postCheckPoint(
                                            // );
                                            _postAbsensi();
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
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            "lokasi belum dimasukan",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                        RoundedButton(
                                          text: "Ambil Lokasi",
                                          press: () {
                                            _absenPresenter
                                                .getUserLocation(context);
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
    List statusColor = [
      Colors.blue,
      Colors.blue[600],
      Colors.orange[800],
      Colors.blueGrey[700],
      Colors.lime[800],
      Colors.yellow[900],
      Colors.lightBlue[200],
      Colors.red[300],
      Colors.blueGrey[400],
      Colors.indigo[300],
      Colors.cyan[600],
      Colors.red,
      Colors.cyan[900],
      Colors.blueGrey[600],
      Colors.blueGrey[900],
      Colors.teal[900],
      Colors.blueGrey,
      Colors.blueGrey,
      Colors.blueGrey
    ];
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
                      Chip(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 0),
                          backgroundColor: statusColor[int.parse(data.isin)],
                          label: Text(
                            data.lokasi,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          )),
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
