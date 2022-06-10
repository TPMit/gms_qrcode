// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:legacy_buttons/legacy_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class DialogTamuDetail extends StatefulWidget {
  const DialogTamuDetail(
      {Key? key,
      required this.pengunjung,
      required this.image,
      required this.name,
      required this.activity,
      required this.waktu,
      required this.status,
      required this.idTamu})
      : super(key: key);
  final String name, pengunjung, idTamu;
  final String image, activity, waktu, status;

  @override
  State<DialogTamuDetail> createState() => _DialogTamuDetailState();
}

class _DialogTamuDetailState extends State<DialogTamuDetail> {

  Future postUpload() async {

    var url =
        Uri.parse('https://gmsnv.mindotek.com/attendance/updatevisitor');
    var request = http.MultipartRequest("POST", url);

    request.fields['idTamu'] = widget.idTamu;
    request.fields['status'] = '0';

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Success");
      Fluttertoast.showToast(
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15);
      Navigator.pushNamed(context, "/tamu");
    } else {
      print("FAILED");
      Fluttertoast.showToast(
          msg: 'Failed',
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pengunjung: " + widget.pengunjung),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("diinput oleh: " + widget.name),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("Tujuan: "+ widget.activity),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("Waktu: " + widget.waktu),
                          const SizedBox(
                            height: 8,
                          ),
                          Image.network(
                        'https://gmsqr.tpm-security.com/assets/imagesofgms/visitor/${widget.image}', height: 250, width: 300,),
                          widget.status == '1' ?
                          Container(
                            padding:
                                const EdgeInsets.only(
                                    top: 8),
                            child: Text('Sedang Berkunjung',
                                style: GoogleFonts
                                    .poppins(
                                        color: Colors
                                            .green,
                                        fontSize:
                                            14)),
                          ) : Container(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text('Tamu sudah selesai',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey, fontSize: 14)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.status == '1' ?
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding:
                                const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                            height: 40,
                            child: LegacyRaisedButton(
                              padding: const EdgeInsets.all(10),
                              color: Colors.blue,
                              disabledColor: Colors.red,
                              onPressed: () async {
                                postUpload();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              child: Text(
                                'Selesai Kunjungan',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
