import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../src/response/keperluan_response.dart';

class SelectKeperluanPage extends StatefulWidget {
  final KeperluanResponse keperluanResponse;
  const SelectKeperluanPage({ Key? key, required this.keperluanResponse }) : super(key: key);

  @override
  State<SelectKeperluanPage> createState() => _SelectKeperluanPageState(keperluanResponse);
}

class _SelectKeperluanPageState extends State<SelectKeperluanPage> {
  late KeperluanResponse _keperluanResponse;
  final controller = TextEditingController();
  Timer? debouncer;
  String query = '';

  _SelectKeperluanPageState(KeperluanResponse keperluanResponse){
    _keperluanResponse = keperluanResponse;
    print(_keperluanResponse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.search),
      //   onPressed: () => bottomSearch(),
      // ),
      appBar: AppBar(
        title: Text('Select Keperluan'),
      ),
      body: ListView.builder(
        itemCount: _keperluanResponse.dataKeperluan!.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 20, right: 20),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: Icon(Ionicons.home),
            title: Text("${_keperluanResponse.dataKeperluan![index].perlu}"),
            onTap: (() {
              print('====select idkeperluan'+index.toString());
              Navigator.pop(context, index);
            }),
          );
        },
      ),
    );
  }

  void bottomSearch() async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        builder: (context) {
          return Scaffold(
            body: Column(
              children: [
                Container(
                  height: 42,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      icon: Icon(Icons.search,
                          color: query.isEmpty ? Colors.black54 : Colors.black),
                      suffixIcon: query.isNotEmpty
                          ? GestureDetector(
                              child: const Icon(Icons.close, color: Colors.black),
                              onTap: () {
                                controller.clear();
                                searchBook('');
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                            )
                          : null,
                      hintText: 'Alamat atau nama',
                      hintStyle: const TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.black),
                    onChanged: searchBook,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future searchBook(String query) async => debounce(() async {
        // _addTamuPresenter.getData(query);
        // if (!mounted) return;
        print(query);
        setState(() {
         _keperluanResponse.dataKeperluan!.where((element) => element.perlu!.toLowerCase().contains(query.toLowerCase())); 
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

}
