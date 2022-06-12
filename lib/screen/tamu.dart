// ignore_for_file: avoid_print

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gms_mobile/src/model/tamu_model.dart';
import 'package:gms_mobile/src/state/tamu_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';

import '../src/model/visitor_model.dart';
import '../src/presenter/tamu_awal_presenter.dart';

import '../src/resources/session.dart';
import 'fragment/activity/dialog_tamu_detail.dart';
import 'fragment/component/background.dart';
import 'package:get_storage/get_storage.dart';
import '../helper/getStorage.dart' as constants;
import 'fragment/loading.dart';
import 'fragment/tamu_add.dart';

class TamuScreen extends StatefulWidget {
  const TamuScreen({Key? key}) : super(key: key);

  @override
  State<TamuScreen> createState() => _TamuScreenState();
}
  int idUser = 0;

class _TamuScreenState extends State<TamuScreen> implements TamuState {

  late TamuModel _tamuModel;
  late TamuPresenter _tamuPresenter;

  _TamuScreenState() {
    _tamuPresenter = TamuPresenter();
  }

  @override
  void initState() {
    super.initState();
    _tamuPresenter.view = this;
    Session.getId().then((value) {
      setState(() {
        idUser = int.parse(value!);
      });
      print('===');
    });
      print(Session.getId());
      _tamuPresenter.getData(GetStorage().read(constants.idSite));
  }

  @override
  Widget build(BuildContext context) {
    return _tamuModel.isloading
        ? Loading()
        : Scaffold(
      appBar: AppBar(
        title: const Text('Aktifitas Tamu hari ini'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home");
            },
            icon: const Icon(LineIcons.arrowLeft)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TamuAddScreen(idUser: idUser,)));
              },
              icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          _tamuModel.tamunya.length == 0
              ? Container(
                  child: Center(
                  child: Text('Belum Ada Aktivitas Yang Dikerjakan',
                      style: GoogleFonts.poppins(
                        fontStyle: FontStyle.italic,
                        textStyle:
                            TextStyle(fontSize: 14, color: Color(0xff1f1f1f)),
                      )),
                ))
              : ListView.builder(
                        itemCount: _tamuModel.tamunya.length,
                        scrollDirection: Axis.vertical,
                        primary: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int itemIndex) =>
                            Container(
                              padding: EdgeInsets.all(8),
                              child: InkWell(
                          onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => DialogTamuDetail(
                                      pengunjung: _tamuModel.tamunya[itemIndex].noVisitor,
                                      image: _tamuModel.tamunya[itemIndex].images,
                                      name: _tamuModel.tamunya[itemIndex].name,
                                      activity: _tamuModel.tamunya[itemIndex].blok,
                                      waktu: _tamuModel.tamunya[itemIndex].tanggal + ' ' + _tamuModel.tamunya[itemIndex].jam,
                                      status: _tamuModel.tamunya[itemIndex].status,
                                      idTamu: _tamuModel.tamunya[itemIndex].id,
                                    ));
                          },
                          child: Container(
                              height: 90,
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Icon(
                                    Ionicons.calendar_outline,
                                    size: 48,
                                    color: Color(0xff485460),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText('no tamu: ' +
                                        _tamuModel.tamunya[itemIndex].noVisitor
                                                .toString() +
                                            ' : ' +
                                            _tamuModel.tamunya[itemIndex].blok
                                                .toString() +
                                            '\n' +
                                            _tamuModel.tamunya[itemIndex].tanggal
                                                .toString(),
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff1f1f1f)),
                                        ),
                                        maxLines: 2,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
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
    );
  }

  @override
  void onError(String error) {
    Fluttertoast.showToast(msg: error,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 15);
  }

  @override
  void onSuccess(String success) {
    
  }

  @override
  void refreshData(TamuModel tamuModel) {
    setState(() {
      _tamuModel = tamuModel;
    });
  }

  @override
  void showDeskripsi(BuildContext context) {
    
  }

  @override
  void showstatusKondisi(BuildContext context) {
    
  }
}

class ActivityList extends StatelessWidget {
  const ActivityList({Key? key, required this.activities}) : super(key: key);
  final List<VisitorModel> activities;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          VisitorModel data = activities[index];
          return GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (context) => DialogTamuDetail(
                      pengunjung: data.tamu,
                      image: data.images,
                      name: data.name,
                      activity: data.blok + '-' + data.penghuni,
                      waktu: data.tanggal + ' ' + data.jam,
                      status: data.status,
                      idTamu: data.id,
                    )),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Column(
                children: [
                  Text(
                    data.blok + '-' + data.penghuni,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('ditambahkan pada ' +
                      DateFormat('kk:mm').format(data.dateTime))
                ],
              ),
            ),
          );
        });
  }
}
