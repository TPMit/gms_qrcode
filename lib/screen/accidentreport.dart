// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../helper/getStorage.dart' as constants;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../src/resources/session.dart';
import 'fragment/component/background.dart';
import 'fragment/component/roundedbutton.dart';
// import 'fragment/component/roundedinputdate.dart';
import 'fragment/component/roundedinputfield.dart';
// import 'fragment/component/roundedinputtime.dart';
import 'fragment/component/textfieldcontainer.dart';

class AccidentReport extends StatefulWidget {
  const AccidentReport({Key? key}) : super(key: key);

  @override
  _AccidentReportState createState() => _AccidentReportState();
}

class _AccidentReportState extends State<AccidentReport> {
  late int idUser = 0;
  File? _image;
  ImagePicker imagePicker = ImagePicker();
  String nik = GetStorage().read(constants.nik);
  String idsite = GetStorage().read(constants.idSite);
  late String _title, _relatedNames, _relatedRemarks, _chronology, _takenAction;
  // String? _date;

  TextEditingController tanggalController = TextEditingController();
  TextEditingController waktuController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  late String _time;

  getPermission() async {
    var cameraPermission = await Permission.camera.status;
    if (!cameraPermission.isGranted) {
      await Permission.camera.request();
    }
  }

  Future getImage(ImageSource imageSource) async {
    var imageFile = await imagePicker.pickImage(source: imageSource);
    try {
      setState(() {
        _image = File(imageFile!.path);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    Session.getId().then((value) {
      setState(() {
        idUser = int.parse(value!);
      });
      print('===');
    });
  }

  Future postUpload() async {
    var stream = http.ByteStream(_image!.openRead());
    stream.cast();
    var length = await _image!.length();
    var url =
        Uri.parse('https://gmsnv.mindotek.com/attendance/uploadaccident');
    var request = http.MultipartRequest("POST", url);
    var multipartFile =
        http.MultipartFile("image", stream, length, filename: 'x.jpg');

    request.files.add(multipartFile);
    request.fields['idsite'] = idsite;
    request.fields['waktu'] = waktuController.text;
    request.fields['tanggal'] = tanggalController.text;
    request.fields['subjek'] = _title;
    request.fields['pihakterkait'] = _relatedNames;
    request.fields['kronologi'] = _chronology;
    request.fields['tindakan'] = _takenAction;
    request.fields['kesimpulan'] = _relatedRemarks;
    request.fields['id_user'] = idUser.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      print("IMAGE UPLOADED");
      Fluttertoast.showToast(
          msg: 'SUKSES',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15);
      Navigator.pushNamed(context, "/home");
    } else {
      print("IMAGE FAILED");
      Fluttertoast.showToast(
          msg: 'FAILED',
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Insiden'),
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Judul',
                        onChanged: (ket) {
                          _title = ket;
                        },
                        icon: FontAwesomeIcons.stickyNote,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // RoundedInputDate(
                          //   width: size.width * 0.40,
                          //   hintText: "Tanggal",
                          //   dateFormat: DateFormat("y-MM-d"),
                          //   // lastDate: DateTime.now().add(Duration(days: 366)),
                          //   lastDate: DateTime.now(),
                          //   firstDate: DateTime(1980, 12),
                          //   initialDate: DateTime.now(),
                          //   onDateChanged: (dvalue) {
                          //     _date = dvalue;
                          //     print(dvalue);
                          //   },
                          // ),
                          TextFieldContainer(
                            width: size.width * 0.4,
                            child: TextField(
                              // focusNode: widget.focusNode,
                              controller: tanggalController,
                              cursorColor: Colors.indigo.shade300,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.teal.shade600,
                                ),
                                labelText: 'Tanggal',
                                border: InputBorder.none,
                              ),
                              onTap: () => showCalender(),
                              readOnly: true,
                            ),
                          ),
                          TextFieldContainer(
                            width: size.width * 0.4,
                            child: TextField(
                              // focusNode: widget.focusNode,
                              controller: waktuController,
                              cursorColor: Colors.indigo.shade300,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.teal.shade600,
                                ),
                                labelText: 'pilih Waktu',
                                border: InputBorder.none,
                              ),
                              onTap: () => showTime(),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Pihak-pihak terkait (Nama/remark dipisah dengan koma (,)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 12),
                      ),
                      RoundedInputField(
                          width: size.width * 0.9,
                          icon: FontAwesomeIcons.users,
                          hintText: 'Nama terkait',
                          onChanged: (names) {
                            _relatedNames = names;
                          }),
                      // RoundedInputField(
                      //     width: size.width * 0.9,
                      //     icon: FontAwesomeIcons.readme,
                      //     hintText: 'Remark',
                      //     onChanged: (remarks) {
                      //       _relatedRemarks = remarks;
                      //     }),
                      BigTextField(
                        onChanged: (kronologi) {
                          _chronology = kronologi;
                        },
                        hint: 'Kronologi',
                      ),
                      BigTextField(
                        onChanged: (action) {
                          _takenAction = action;
                        },
                        hint: 'Tindakan yg diambil',
                      ),
                      BigTextField(
                        onChanged: (kesimpulan) {
                          _relatedRemarks = kesimpulan;
                        },
                        hint: 'Kesimpulan',
                      ),
                      _image == null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Tambahkan Foto?',
                                    style: TextStyle(color: Colors.grey[800]),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            getImage(ImageSource.camera);
                                          },
                                          icon: const FaIcon(
                                            FontAwesomeIcons.camera,
                                            color: Colors.teal,
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "|",
                                          style: TextStyle(color: Colors.teal),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                          },
                                          icon: const FaIcon(
                                            FontAwesomeIcons.image,
                                            color: Colors.teal,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  _image = null;
                                });
                              },
                              child: Image.file(
                                _image!,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                errorBuilder: (context, error, stactTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    width: 100,
                                    height: 100,
                                    child: const Center(
                                      child: Text('Error load image',
                                          textAlign: TextAlign.center),
                                    ),
                                  );
                                },
                              ),
                            ),
                      RoundedButton(
                          text: 'Laporkan',
                          color: Colors.teal.shade800,
                          press: () {
                            if (_image != null) {
                              if(waktuController.text != ''){
                                if(tanggalController.text != ''){
                                  postUpload();
                                  print(idsite);
                                  print(waktuController.text);
                                  print(tanggalController.text);
                                  print(_title);
                                  print(_relatedNames);
                                  print(_chronology);
                                  print(_takenAction);
                                  print(_relatedRemarks);
                                  print(idUser.toString());
                                }else{
                                  print('tanggal belum ditambah');
                                  Fluttertoast.showToast(
                                      msg: 'tanggal belum ditambah',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 15);
                                }
                              }else{
                                print('waktu belum ditambah');
                                Fluttertoast.showToast(
                                    msg: 'waktu belum ditambah',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 15);
                              }
                            } else {
                              print('foto belum ditambah');
                              Fluttertoast.showToast(
                                  msg: 'foto belum ditambah',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 15);
                            }
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
          // Positioned(
          //   bottom: 30,
          //   right: 30,
          //   child: FloatingActionButton(
          //     onPressed: () {},
          //     child: FaIcon(FontAwesomeIcons.folderPlus),
          //   ),
          // )
        ],
      ),
    );
  }
  void showCalender() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1970, 1, 1, 11, 33),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        print('===' + value.toString());
        tanggalController.text =
            DateFormat("yyyy-MM-dd").format(value.toLocal()).toString();
      });
    });
  }

  void showTime() {
    showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        selectedTime = value;
        _time =
            selectedTime.hour.toString() + ':' + selectedTime.minute.toString();
        waktuController.text = _time;
      });
    });
  }
}

class BigTextField extends StatelessWidget {
  const BigTextField({Key? key, required this.hint, required this.onChanged})
      : super(key: key);
  final String hint;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
          onChanged: onChanged,
          autocorrect: false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration.collapsed(
            hintText: hint,
          )),
    );
  }
}
