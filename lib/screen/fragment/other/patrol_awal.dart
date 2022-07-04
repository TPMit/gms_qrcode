// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_is_empty, avoid_print

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gms_mobile/screen/fragment/component/ligh_colors.dart';
import 'package:gms_mobile/src/model/patrol_model.dart';
import 'package:gms_mobile/src/state/patrol_state.dart';

import '../../../src/presenter/patrol_presenter.dart';
import '../../../src/resources/session.dart';
import '../../patrol.dart';
// import '../activity/dialogpatroldetail.dart';
import '../component/clipath.dart';
import '../loading.dart';
import 'package:gms_mobile/helper/getStorage.dart' as constant;

import '../patrol/patrol_detail_screen.dart';

class PatrolAwalScreen extends StatefulWidget {
  const PatrolAwalScreen({Key? key}) : super(key: key);

  @override
  _PatrolAwalScreenState createState() => _PatrolAwalScreenState();
}


class _PatrolAwalScreenState extends State<PatrolAwalScreen>
    with SingleTickerProviderStateMixin
    implements PatrolState {
  String barcode = "";
  late String idUser = "";
  late TabController tabController;
  late PatrolModel _patrolModel;
  late PatrolPresenter _patrolPresenter;

  _PatrolAwalScreenState() {
    _patrolPresenter = PatrolPresenter();
  }

  @override
  void initState() {
    super.initState();
    _patrolPresenter.view = this;
    tabController = TabController(length: 2, vsync: this);
    Session.getId().then((value) {
      setState(() {
        idUser = value.toString();
        print('===');
        _patrolPresenter.newCheckpoint(value.toString(), GetStorage().read(constant.idSite));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _patrolModel.isloading
        ? const Loading()
        : Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("refresh"),
        onPressed: () {
          setState(() {
            _patrolModel.patrolAwal.clear();
            _patrolPresenter.newCheckpoint(
                idUser, GetStorage().read(constant.idSite));
          });
        },
      ),
      body: Stack(
              children: [
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xffecedf2),
                        height: 230.0,
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Stack(
                          children: <Widget>[
                            ClipPath(
                              clipper: TClipper(),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 270.0,
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
                              top: 10,
                              child: IconButton(
                                icon: const Icon(
                                  Ionicons.arrow_back,
                                  color: Colors.white,
                                ),
                                iconSize: 24,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Positioned(
                              top: 60,
                              left: 35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Check Point Patroli',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      "klik tombol 'tambah' untuk menambahkan patroli hari ini",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                  Center(
                                    child: InkWell(
                                      splashColor: const Color(0xff7474BF),
                                      onTap: () async {
                                        print(_patrolModel.idCheckpoint);
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => 
                                           PatrolScreen(idCheckout: _patrolModel.idCheckpoint)
                                        ));
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
                                        height: 41,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(0, 28),
                                                  blurRadius: 40,
                                                  spreadRadius: -12)
                                            ],
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: const Center(
                                          child: Text(
                                            "Mulai Patrol",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      this._patrolModel.patrolAwal.length == 0
                          ? Container(
                              child: Center(
                              child: Text('Belum Ada Checkpoint Yang Dikerjakan',
                                  style: GoogleFonts.poppins(
                                    fontStyle: FontStyle.italic,
                                    textStyle: TextStyle(
                                        fontSize: 14, color: Color(0xff1f1f1f)),
                                  )),
                            ))
                          : Expanded(
                              child: Container(
                              padding: EdgeInsets.all(20),
                              width: MediaQuery.of(context).size.width,
                              height: double.infinity,
                              color: Color(0xffecedf2),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                        itemCount:
                                            this._patrolModel.patrolAwal.length,
                                        scrollDirection: Axis.vertical,
                                        primary: false,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context,
                                                int itemIndex) =>
                                            InkWell(
                                          onTap: () {
                                            // _patrolPresenter.getDetailPatrol(context, _patrolModel.patrolAwal[itemIndex].idQrcode);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PatrolDetailScreen(
                                                            idCheckout:
                                                                int.parse(
                                                                    _patrolModel
                                                                    .patrolAwal[
                                                                        itemIndex]
                                                                    .idQrcode,
                                                            ),
                                                            uname: _patrolModel
                                                                .patrolAwal[
                                                                    itemIndex]
                                                                .username,
                                                            idSite: _patrolModel.patrolAwal[itemIndex].idSite,
                                                              )));
                                          },
                                          child: Container(
                                            height: 88,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceAround,
                                              children: <Widget>[
                                                new Icon(
                                                  Ionicons.shield_checkmark_outline,
                                                  size: 24,
                                                  color: Color(0xff485460),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AutoSizeText(
                                                      _patrolModel
                                                              .patrolAwal[
                                                                  itemIndex]
                                                              .username +
                                                          ' :\n' +
                                                          _patrolModel
                                                              .patrolAwal[
                                                                  itemIndex]
                                                              .label +
                                                          '\n' +
                                                          _patrolModel
                                                              .patrolAwal[
                                                                  itemIndex]
                                                              .currentdatetime,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff1f1f1f)),
                                                      ),
                                                      maxLines: 3,
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                Icon(
                                                  Ionicons.chevron_forward,
                                                  size: 24,
                                                  color: Color(0xffe5e5e5),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  @override
  void onError(String error) {
    
  }

  @override
  void onSuccess(String success) {
    
  }

  @override
  void onSuccessUnCondusif(String success) {
    
  }

  @override
  void refreshData(PatrolModel patrolModel) {
    setState(() {
      _patrolModel = patrolModel;
    });
  }

  @override
  void scan(String idTag) {
    
  }

  @override
  void showDeskripsi(BuildContext context) {
    
  }

  @override
  void showstatusKondisi(BuildContext context) {
    
  }

  @override
  void showStatusLokasi(BuildContext context) {
    
  }

  @override
  void showDetailPatrol(BuildContext context, String idCheck) {
    print('go patrol');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PatrolScreen(idCheckout: int.parse(idCheck))));
  }
}