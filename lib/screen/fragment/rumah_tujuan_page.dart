import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gms_mobile/src/model/add_tamu_model.dart';
import 'package:gms_mobile/src/state/add_tamu_state.dart';
import 'package:ionicons/ionicons.dart';

import '../../src/presenter/add_tamu_presenter.dart';
import '../../src/response/penghuni_response.dart';
import 'component/search_tamu.dart';

class SelectRumahTujuanPage extends StatefulWidget {
  final PenghuniResponse penghuniResponse;
  const SelectRumahTujuanPage({Key? key, required this.penghuniResponse})
      : super(key: key);

  @override
  State<SelectRumahTujuanPage> createState() =>
      _SelectRumahTujuanPageState(penghuniResponse);
}

class _SelectRumahTujuanPageState extends State<SelectRumahTujuanPage> implements AddTamuState {
  late PenghuniResponse _penghuniResponse;
  final controller = TextEditingController();
  Timer? debouncer;
  String query = '';
  late bool isLoading = false;

  late AddTamuModel _addTamuModel;
  late AddTamuPresenter _addTamuPresenter;

  _SelectRumahTujuanPageState(PenghuniResponse penghuniResponse) {
    _penghuniResponse = penghuniResponse;
    print(_penghuniResponse);
    _addTamuPresenter = AddTamuPresenter();
  }

  @override
  void initState() {
    super.initState();
    _addTamuPresenter.view = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.search),
      //   onPressed: () => bottomSearch(),
      // ),
      appBar: AppBar(
        title: Text('Select Rumah Tujuan'),
      ),
      body: Column(
        children: [
          buildSearch(),
          _addTamuModel.isLoading
                ? Center(child: CircularProgressIndicator(),) 
          : Expanded(
            child: ListView.builder(
              itemCount: _penghuniResponse.dataPenghuni!.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 20, right: 20),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(Ionicons.home),
                  title: Text("${_penghuniResponse.dataPenghuni![index].blok}" + " - " + "${_penghuniResponse.dataPenghuni![index].kategori}"),
                  onTap: (() {
                    Navigator.pop(context, index);
                  }),
                );
              },
            ),
          ),

        ],
      )
    );
  }

  Widget buildSearch() => SearchTamuWidget(
        text: query,
        hintText: 'nama blocnya',
        onChanged: searchBook,
      );

  Future searchBook(String query) async => debounce(() async {
      
        if (!mounted) return;

        setState(() {
          _addTamuPresenter.getDataPenghuninya(query);
        });
      });

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  void onError(String error) {
    Fluttertoast.showToast(
        msg: error,
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
  void refreshData(AddTamuModel addTamuModel) {
    setState(() {
      _addTamuModel = addTamuModel;
    });
  }

  @override
  void refreshDataRumah(PenghuniResponse penghuniResponse) {
    setState(() {
      _penghuniResponse = penghuniResponse;
    });
  }

  @override
  void refreshLoading(bool isLoading) {
    setState(() {
      _addTamuModel.isLoading = isLoading;
    });
  }
}
