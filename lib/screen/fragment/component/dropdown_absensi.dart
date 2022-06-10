// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:gms_mobile/screen/fragment/component/roundedbutton.dart';
import 'package:gms_mobile/screen/fragment/component/roundeddropdown.dart';
import 'package:gms_mobile/screen/fragment/component/roundedinputfield.dart';
import '../../../src/response/listabsensi_response.dart';
import 'package:http/http.dart' as http;


class DropdownSelectAbsensi extends StatefulWidget {
  final String idUser;
  final String hasilQr;
  final String latitudeLongitude;
  const DropdownSelectAbsensi({Key? key, required this.idUser, required this.hasilQr, required this.latitudeLongitude})

      : super(key: key);
  @override
  State<DropdownSelectAbsensi> createState() => _DropdownSelectAbsensiState();
}

class _DropdownSelectAbsensiState extends State<DropdownSelectAbsensi> {
  int selectedAbsensi = 1;
  bool showInputHour = false;
  String? hour;

  DateTime now = DateTime.now();

  _postAbsensi() async {
    Map<String, dynamic> content = <String, dynamic>{};
    content['id_user'] = widget.idUser;
    content['tagid'] = widget.hasilQr;
    content['id_shift'] = selectedAbsensi.toString();
    content['thetime'] = DateFormat('kk:mm').format(now);
    content['latitude_longitude_in'] = widget.latitudeLongitude;
    content['hours'] = hour ?? '0';
    // content['latitude_longitude_in'] = latitude.toString() +
    //     ', ' +
    //     longitude.toString();
    var response = await http.post(
      Uri.https('gmsnv.mindotek.com', 'attendance/absenbydanru'),
      body: content,
    );
    if (response.statusCode == 200) {
      print('success');
      Fluttertoast.showToast(
          msg: 'input absen Berhasil',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15);
      Navigator.pop(context);
    } else {
      print('failed');
      Fluttertoast.showToast(msg: 'Upload gagal',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListAbsensiStatus>>(
                                    future: ListAbsensiStatusService.get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Center(
                                          child: Text('An error has occurred!'),
                                        );
                                      } else if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        return Column(
                                          children: [
                                            RoundedDropdown(
                                                value: selectedAbsensi,
                                                hintText: 'Pilih..',
                                                // icon: Icons.timelapse,
                                                items:
                                                    snapshot.data!.map((item) {
                                                  return DropdownMenuItem(
                                                    child: Text(
                                                      item.keterangan,
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    value: int.parse(item.id),
                                                  );
                                                }).toList(),
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    print("===selected:" +
                                                        value.toString());
                                                    selectedAbsensi = value!;
                                                    if (selectedAbsensi == 15 ||
                                                        selectedAbsensi == 16) {
                                                      showInputHour = true;
                                                    } else {
                                                      showInputHour = false;
                                                    }
                                                  });
                                                  print(selectedAbsensi);
                                                  print(showInputHour);
                                                }),
                                            Visibility(
                                                visible: showInputHour,
                                                child: RoundedInputField(
                                                  inputType:
                                                      TextInputType.number,
                                                  icon: FontAwesomeIcons
                                                      .sortNumericUp,
                                                  hintText: 'banyak jam',
                                                  onChanged: (String hours) {
                                                    setState(() {
                                                      hour = hours;
                                                    });
                                                  },
                                                )),
                                            RoundedButton(
                                              text: 'Serahkan',
                                              color: Colors.teal,
                                              press: () {
                                                print('==start==');
                                                print(selectedAbsensi.toString());
                                                print(widget.hasilQr);
                                                print(widget.idUser);
                                                print(widget.latitudeLongitude);
                                                print('==end==');
                                                _postAbsensi();
                                              }),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    DateFormat(
                                                            'dd/MM/yyyy kk:mm')
                                                        .format(now),
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  )),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  );
  }
}
