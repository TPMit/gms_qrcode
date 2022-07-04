// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_is_empty, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../activity/dialog_patrol_detail.dart';
import '/../src/model/patrol_model.dart';
import '/../src/presenter/patrol_presenter.dart';
import '/../src/state/patrol_state.dart';
import '../component/app_color.dart';
import '../component/roundedbutton.dart';
import '../loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PatrolDetailScreen extends StatefulWidget {
  final int idCheckout;
  final String uname, idSite;
  const PatrolDetailScreen({Key? key, required this.idCheckout, required this.idSite, required this.uname}) : super(key: key);

  @override
  _PatrolDetailScreenState createState() => _PatrolDetailScreenState();
}

int idUser = 0;
int idTag = 2;

class _PatrolDetailScreenState extends State<PatrolDetailScreen>
    with SingleTickerProviderStateMixin
    implements PatrolState {
  String barcode = "";
  ScanResult? scanResult;
  late PatrolModel _patrolModel;
  late PatrolPresenter _patrolPresenter;
  late TabController tabController;

  DateTime now = DateTime.now();

  _PatrolDetailScreenState() {
    _patrolPresenter = PatrolPresenter();
  }

  @override
  void initState() {
    super.initState();
    _patrolPresenter.view = this;
    _patrolPresenter.getCheckpointTag(now.hour.toString() + ":" + now.minute.toString(), widget.idSite, widget.idCheckout);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _patrolModel.isloading
          ? const Loading()
          : SafeArea(
        child: Container(
          color: Color(0xff51557E),
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///vertical spacing
              const SizedBox(
                height: 16,
              ),
      
              ///Container for actionables
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Daftar Checkpoint " + widget.uname,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  
                  IconButton(
                    icon: const Icon(
                      Icons.info_outline,
                      color: AppColors.veryLightTextColor,
                      size: 30,
                    ), onPressed: () { 
                      print('test');
                     },
                  )
                ],
              ),
      
              ///vertical spacing
              const SizedBox(
                height: 16,
              ),
      
              ///Container for places list
              Expanded(
                child: Container(
                  color: Color(0xff1B2430),
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ListView.builder(
                          itemCount: _patrolModel.patrol.length,
                          scrollDirection: Axis.vertical,
                          primary: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int itemIndex) =>
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                        context: context,
                                        builder: (context) => DialogPatrolDetail(
                                          image: _patrolModel.patrol[itemIndex].images,
                                          name: widget.uname,
                                          activity: _patrolModel.patrol[itemIndex].lokasi, 
                                          jam: _patrolModel.patrol[itemIndex].jam,
                                          status: _patrolModel.patrol[itemIndex].status,
                                          statuslokasi: _patrolModel.patrol[itemIndex].statusLokasi,
                                        ));
                          },
                          child: Container(
                              margin: const EdgeInsets.all(20),
                              height: 150,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                  'https://gmsnv.mindotek.com/assets/imagesofgms/lokasitag/' +
                                                      _patrolModel
                                                          .patrol[itemIndex]
                                                          .images,
                                                  fit: BoxFit.cover),
                                            ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight: Radius.circular(20)),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.7),
                                                  Colors.transparent
                                                ]))),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                              child: _patrolModel.patrol[itemIndex].status =='0'
                                                  ? Container(
                                                              color: Colors
                                                                  .grey[200],
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: const Icon(
                                                                  LineIcons
                                                                      .lock)) 
                                              :_patrolModel.patrol[itemIndex].status =='1' && _patrolModel.patrol[itemIndex].statusLokasi =='0'
                                              ? Container(
                                                  color: Colors.red[400],
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: const Icon(LineIcons.times))
                                              : Container(color: Colors.green[200], padding: const EdgeInsets.all(10), child: const Icon(LineIcons.doubleCheck))
                                            ),
                                          const SizedBox(width: 10),
                                          Text(_patrolModel.patrol[itemIndex].lokasi + '\n' + _patrolModel.patrol[itemIndex].label,
                                              style:
                                              _patrolModel.patrol[itemIndex].status =='0'
                                              ? const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14)
                                              : _patrolModel.patrol[itemIndex].status =='1' && _patrolModel.patrol[itemIndex].statusLokasi =='0'
                                              ? const TextStyle(
                                                              color:
                                                                  Colors.red,
                                                              fontSize: 14)
                                              : const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 14) 
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),

                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onError(String error) {
    print(error);
    Fluttertoast.showToast(msg: error,
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 2,
             backgroundColor: Colors.amber,
             textColor: Colors.white,
             fontSize: 15);
  }
  

  @override
  void onSuccess(String success) {
    print(success);
    setState(() {
    _patrolPresenter.getCheckpointTag(
          now.hour.toString() + ":" + now.minute.toString(),
          widget.idSite,
          widget.idCheckout);
    });
    Fluttertoast.showToast(msg: 'CheckPoint berhasil dilewati',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.amber,
      textColor: Colors.white,
      fontSize: 15);
    Navigator.pop(context);
  }

  @override
  void onSuccessUnCondusif(String success) {
    print(success);
    setState(() {
      _patrolPresenter.getCheckpointTag(
          now.hour.toString() + ":" + now.minute.toString(),
          widget.idSite,
          widget.idCheckout);
    });
    Fluttertoast.showToast(
        msg: 'CheckPoint berhasil dilewati',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.amber,
        textColor: Colors.white,
        fontSize: 15);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void refreshData(PatrolModel patrolModel) {
    setState(() {
      _patrolModel = patrolModel;
    });
  }

  @override
  void scan(String idTag) async {
    print('mulai scan 2');
    try {
      final result = await BarcodeScanner.scan();
      setState(() {
        scanResult = result;
      });
      print(scanResult!.rawContent.toString());
      if (scanResult!.rawContent.toString() != "") {
        _patrolPresenter.checkKondisi(context, idTag, scanResult!.rawContent.toString());
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
  void showStatusLokasi(BuildContext context) {
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
                              const SizedBox(width: 8),
                              Text('Your latitude: ${_patrolModel.latitude}'),
                              const SizedBox(width: 8),
                              Text(
                                  'Your longtitude: ${_patrolModel.longitude}'),
                              _patrolModel.location
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      RoundedButton(
                                        text: "Kondusif",
                                        press: () async {
                                            print(idUser.toString());
                                          setState(() {
                                            _patrolModel.isKondusif = 1;
                                            _patrolModel.desc = "";
                                          });
                                          _patrolPresenter.postCheckPoint(
                                            _patrolModel.idTags,
                                              idUser.toString(),
                                              _patrolModel.hasilQr,
                                              1,
                                              _patrolModel.desc,
                                              _patrolModel.latitude
                                                        .toString() +
                                                    ',' +
                                                    _patrolModel.longitude
                                                        .toString());
                                        },
                                        color: Colors.blue,
                                      ),
                                      RoundedButton(
                                        text: "Tidak Kondusif",
                                        press: () {
                                          setState(() {
                                            _patrolModel.isKondusif = 0;
                                          });
                                          _patrolPresenter.checkDeskripsi(context, 0);
                                        },
                                        color: Colors.red.shade400,
                                      ),
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
                                            _patrolPresenter
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
                    RoundedButton(
                      text: "Kondusif",
                      press: () async {
                          print(idUser.toString());
                        setState(() {
                          _patrolModel.isKondusif = 1;
                          _patrolModel.desc = "";
                        });
                        // _patrolPresenter.postCheckPoint(
                        //   _patrolModel.idTags,
                        //     idUser.toString(),
                        //     _patrolModel.hasilQr,
                        //     1,
                        //     _patrolModel.desc);
                      },
                      color: Colors.blue,
                    ),
                    RoundedButton(
                      text: "Tidak Kondusif",
                      press: () {
                        setState(() {
                          _patrolModel.isKondusif = 0;
                        });
                        _patrolPresenter.checkDeskripsi(context, 0);
                      },
                      color: Colors.red.shade400,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void showDeskripsi(BuildContext context) {
    showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => Material(
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.all(15),
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                      onChanged: (value) async {
                        _patrolModel.desc = value;
                      },
                      autocorrect: false,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration.collapsed(
                        hintText: "",
                      )),
                ),
                Center(
                  child: InkWell(
                    splashColor: const Color(0xff7474BF),
                    onTap: () async {
                      _patrolPresenter.postCheckPointUnCondusif(_patrolModel.idTags,idUser.toString(),
                          _patrolModel.hasilQr, 2, _patrolModel.desc,
                          _patrolModel.latitude.toString() +
                              ',' +
                              _patrolModel.longitude.toString());
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      height: 43,
                      width: 120,
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 28),
                                blurRadius: 40,
                                spreadRadius: -12)
                          ],
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Center(
                        child: Text(
                          "tambah",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void showDetailPatrol(BuildContext context, String idCheck) {
    
  }
}
