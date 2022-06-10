// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gms_mobile/screen/fragment/loading.dart';
import 'package:gms_mobile/src/model/jumlah_pengunjung_model.dart';

import '../src/presenter/jumlah_pengunjung_presenter.dart';
import '../src/state/jumlah_pengunjung_state.dart';
import 'package:get_storage/get_storage.dart';
import '../helper/getStorage.dart' as constants;

class JumlahPengunjungScreen extends StatefulWidget {
  const JumlahPengunjungScreen({ Key? key }) : super(key: key);

  @override
  State<JumlahPengunjungScreen> createState() => _JumlahPengunjungScreenState();
}

class _JumlahPengunjungScreenState extends State<JumlahPengunjungScreen> implements JumlahPengunjungState {

  late JumlahPengunjungModel _jumlahPengunjungModel;
  late JumlahPengunjungPresenter _jumlahPengunjungPresenter;

  _JumlahPengunjungScreenState() {
    _jumlahPengunjungPresenter = JumlahPengunjungPresenter();
  }

  @override
  void initState() {
    super.initState();
    _jumlahPengunjungPresenter.view =this;
    _jumlahPengunjungPresenter.getData(GetStorage().read(constants.idSite));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _jumlahPengunjungModel.isLoading ? const Loading()
    : SafeArea(
      child: Scaffold(
        body: Container(
                // it will cover 90% of our total width
                width: size.width * 0.9,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 5),
                      blurRadius: 50,
                      color: const Color(0xFF12153D).withOpacity(0.2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(
                                  // text: "${movie.rating}/",
                                  text: "Total Pengunjung cluster : ",
                                  style: TextStyle( 
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                // TextSpan(text: "10\n"),
                                TextSpan(
                                  text: _jumlahPengunjungModel.rasioGrade[0].total + ' orang',
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
  void refreshData(JumlahPengunjungModel jumlahPengunjungModel) {
    setState(() {
      _jumlahPengunjungModel = jumlahPengunjungModel;
    });
  }
}