// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gms_mobile/screen/fragment/loading.dart';
import 'package:gms_mobile/screen/fragment/rumah_tujuan_page.dart';
import 'package:gms_mobile/src/response/penghuni_master_response.dart';
import 'package:gms_mobile/src/response/penghuni_response.dart';
import '../../helper/getStorage.dart' as constants;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../src/model/add_tamu_model.dart';
import '../../src/presenter/add_tamu_presenter.dart';
import '../../src/state/add_tamu_state.dart';
import '../fragment/component/background.dart';
import '../fragment/component/roundedbutton.dart';
import '../fragment/component/roundedinputfield.dart';
import 'component/textfieldcontainer.dart';
import 'keperluan_page.dart';

class TamuAddScreen extends StatefulWidget {
  final int idUser;

  const TamuAddScreen({Key? key, required this.idUser}) : super(key: key);

  @override
  _TamuAddScreenState createState() => _TamuAddScreenState();
}

class _TamuAddScreenState extends State<TamuAddScreen> implements AddTamuState {
  // late bool _isLoading = false;

  late AddTamuModel _addTamuModel;
  late AddTamuPresenter _addTamuPresenter;

  _TamuAddScreenState() {
    _addTamuPresenter = AddTamuPresenter();
  }

  File? _image;
  ImagePicker imagePicker = ImagePicker();
  String nik = GetStorage().read(constants.nik);
  String namaPetugas = GetStorage().read(constants.namaUser);
  String idsite = GetStorage().read(constants.idSite);
  TimeOfDay selectedTime = TimeOfDay.now();
  late String _nomerTamu;
  late String _time;

  final controller = TextEditingController();

  String query = '';

  Timer? debouncer;
  // List<ListPenghuniResponse> penghunis = [];

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

  Future postUpload() async {
    var stream = http.ByteStream(_image!.openRead());
    stream.cast();
    var length = await _image!.length();
    var url =
        Uri.parse('https://gmsnv.mindotek.com/attendance/uploadvisitor');
    var request = http.MultipartRequest("POST", url);
    var multipartFile =
        http.MultipartFile("image", stream, length, filename: 'x.jpg');

    request.files.add(multipartFile);
    request.fields['tamu'] = _nomerTamu;
    request.fields['tanggal'] = _addTamuModel.tanggalController.text;
    request.fields['jam'] = _addTamuModel.waktuController.text;
    request.fields['id_penghuni'] = _addTamuModel.idPenghuni;
    request.fields['id_perlu'] = _addTamuModel.idKeperluan;
    request.fields['keterangan_perlu'] = _addTamuModel.keteranganPerluController.text;
    request.fields['id_user'] = widget.idUser.toString();
    request.fields['id_site'] = GetStorage().read(constants.idSite);
    try {
      print('go');
      print(request.fields);
      var response = await request.send();
      if (response.statusCode == 200) {
        print("IMAGE UPLOADED");
        Fluttertoast.showToast(
            msg: 'Berhasil',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 15);
        Navigator.pop(context);
        setState(() {
          // _isLoading = false;
          _addTamuModel.isLoading = false;
          refreshData(_addTamuModel);
        });
      } else {
        print("IMAGE FAILED");
        Fluttertoast.showToast(
            msg: 'Failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 15);
        setState(() {
          // _isLoading = false;
          _addTamuModel.isLoading = false;
          refreshData(_addTamuModel);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _addTamuPresenter.view = this;
    getPermission();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    debouncer?.cancel();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    // final penghuni = await ListAbsenService.getMemberPenghuni(query);
    _addTamuPresenter.getData('');
    _addTamuPresenter.getDataKeperluan('');
    // setState(() {
    //   penghunis = penghuni;
    // });
  }

  void selectKeperluan() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectKeperluanPage(
                  key: Key("1"),
                  keperluanResponse: _addTamuModel.keperluannya,
                ))).then((value) => {
          if (value != null)
            {
              setState(() {
                _addTamuModel.idKeperluan = _addTamuModel
                    .keperluannya.dataKeperluan![value].idPerlu
                    .toString();
                _addTamuModel.keperluanController.text = _addTamuModel
                    .keperluannya.dataKeperluan![value].perlu
                    .toString();
                refreshData(_addTamuModel);
              })
            }
        });
  }

  void selectRumahTujuan() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectRumahTujuanPage(
                  key: Key("1"),
                  penghuniResponse: _addTamuModel.penghuninya,
                ))).then((value) => {
          if (value != null)
            {
              setState(() {
                _addTamuModel.idPenghuni = _addTamuModel
                    .penghuninya.dataPenghuni![value].idPenghuni
                    .toString();
                _addTamuModel.rumahController.text = _addTamuModel
                        .penghuninya.dataPenghuni![value].blok
                        .toString() +
                    ' - ' +
                    _addTamuModel.penghuninya.dataPenghuni![value].kategori
                        .toString();
                refreshData(_addTamuModel);
              })
            }
        });
  }

  Widget buildTamu(ListPenghuniResponse listPenghuniModel) =>
      _addTamuModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                setState(() {
                  _addTamuModel.rumahController.text =
                      listPenghuniModel.blok.toString() +
                          ' - ' +
                          listPenghuniModel.kategori.toString();
                  _addTamuModel.idPenghuni = listPenghuniModel.idPenghuni;
                  refreshData(_addTamuModel);
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    listPenghuniModel.blok + ' - ' + listPenghuniModel.kategori,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _addTamuModel.isLoading
    ? Loading()
    : Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Tamu'),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Nomer Tamu',
                        onChanged: (ket) {
                          setState(() {
                            _nomerTamu = ket;
                          });
                        },
                        inputType: TextInputType.number,
                        icon: FontAwesomeIcons.stickyNote,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // RoundedInputDate(
                          //   width: size.width * 0.45,
                          //   hintText: "Tanggal",
                          //   dateFormat: DateFormat("y-MM-d"),
                          //   // lastDate: DateTime.now().add(Duration(days: 366)),
                          //   lastDate: DateTime.now(),
                          //   firstDate: DateTime(1980, 12),
                          //   initialDate: DateTime.now(),
                          //   onDateChanged: (dvalue) {
                          //     setState(() {
                          //     _date = dvalue;
                          //     print(dvalue);
                          //     });
                          //   },
                          // ),
                          TextFieldContainer(
                            width: size.width * 0.4,
                            child: TextField(
                              // focusNode: widget.focusNode,
                              controller: _addTamuModel.tanggalController,
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
                          // RoundedInputTime(
                          //     hintText: 'pilih Waktu',
                          //     onTimeChanged: (time) {
                          //       setState(() {
                          //       _time = time;

                          //       });
                          //     },
                          //     width: size.width * 0.4),
                          TextFieldContainer(
                            width: size.width * 0.4,
                            child: TextField(
                              // focusNode: widget.focusNode,
                              controller: _addTamuModel.waktuController,
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
                        'Pihak-pihak terkait',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 12),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     left: 40,
                      //     right: 40,
                      //     top: 8,
                      //     bottom: 8,
                      //   ),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       _addTamuModel.rumahController.text.isEmpty
                      //       ? Text(
                      //         'Pilih Alamat Tujuan',
                      //         style: TextStyle(
                      //                   color: Color.fromARGB(255, 79, 78, 78), fontStyle: FontStyle.italic),
                      //       )
                      //       : Text(
                      //         _addTamuModel.rumahController.text,
                      //         style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.bold),
                      //       ),
                      //     IconButton(
                      //       onPressed: () {
                      //         selectJenjangnya();
                      //       },
                      //       icon: const FaIcon(
                      //         FontAwesomeIcons.home,
                      //         color: Colors.teal,
                      //       )),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          right: 40,
                          bottom: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _addTamuModel.rumahController.text.isEmpty
                                ? Text(
                                    'Pilih Alamat Tujuan',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 79, 78, 78),
                                        fontStyle: FontStyle.italic),
                                  )
                                : Text(
                                    _addTamuModel.rumahController.text,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                            IconButton(
                                onPressed: () {
                                  selectRumahTujuan();
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.home,
                                  color: Colors.teal,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          right: 40,
                          bottom: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _addTamuModel.keperluanController.text.isEmpty
                                ? Text(
                                    'Pilih Keperluan',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 79, 78, 78),
                                        fontStyle: FontStyle.italic),
                                  )
                                : Text(
                                    _addTamuModel.keperluanController.text,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                            IconButton(
                                onPressed: () {
                                  selectKeperluan();
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.bell,
                                  color: Colors.teal,
                                )),
                          ],
                        ),
                      ),
                      // Container(
                      //   width: size.width * 0.9,
                      //   margin: const EdgeInsets.only(
                      //       top: 4, left: 16, bottom: 1, right: 16),
                      //   decoration: const BoxDecoration(
                      //       color: Colors.transparent,
                      //       border: Border(
                      //         bottom: BorderSide(
                      //             width: 1, color: Color(0xff2D8EFF)),
                      //       )),
                      //   child: TextFormField(
                      //     // initialValue: new DateFormat("d, MMMM - y").format(this._signUpModel.tanggalLahir.toLocal()).toString(),
                      //     style: const TextStyle(color: Colors.grey, fontSize: 14),
                      //     decoration: const InputDecoration(
                      //         icon: Icon(
                      //           Ionicons.home,
                      //           color: Colors.green,
                      //           size: 18,
                      //         ),
                      //         hintText: "Sekolah",
                      //         border: InputBorder.none,
                      //         errorStyle:
                      //              TextStyle(color: Colors.red, fontSize: 9),
                      //         fillColor: Colors.grey,
                      //         hintStyle: TextStyle(
                      //             color: Color(0xff2D8EFF), fontSize: 12)),
                      //     onTap: (() => {
                      //           selectJenjangnya()
                      //         }),
                      //     controller: sekolahController,
                      //     readOnly: true,
                      //   ),
                      // ),
                      _addTamuModel.idKeperluan == '1'
                      ? RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Kepentingan berkunjung',
                        onChanged: (ket) {
                          setState(() {
                            _addTamuModel.keteranganPerluController.text = ket;
                          });
                        },
                        icon: FontAwesomeIcons.atlas,
                      )
                      : SizedBox(),
                      _image == null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Tambahkan Foto KTP?',
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
                      _addTamuModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : RoundedButton(
                              text: 'Laporkan',
                              color: Colors.teal.shade800,
                              press: () {
                                if (_image != null) {
                                  if (_addTamuModel.idPenghuni != '' &&
                                      _addTamuModel.rumahController.text !=
                                          '') {
                                    if (_addTamuModel.waktuController.text !=
                                        '') {
                                      if (_addTamuModel
                                              .tanggalController.text !=
                                          '') {
                                            if(_addTamuModel.idKeperluan != ''){
                                              print(_nomerTamu);
                                              print(_addTamuModel.tanggalController.text);
                                              print(_addTamuModel.waktuController.text);
                                              print(_addTamuModel.idPenghuni);
                                              print(_addTamuModel.idKeperluan);
                                              print(_addTamuModel.keteranganPerluController.text);
                                              print(widget.idUser.toString());
                                              postUpload();
                                              setState(() {
                                                _addTamuModel.isLoading = true;
                                                refreshData(_addTamuModel);
                                              });
                                            }else{
                                              print('Keperluan belum ditambah');
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Keperluan belum ditambah',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 2,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 15);
                                            }
                                      } else {
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
                                    } else {
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
                                    print(_addTamuModel.idPenghuni);
                                    print('tujuan belum ditambah');
                                    Fluttertoast.showToast(
                                        msg: 'tujuan belum ditambah',
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
                                  // Get.snackbar('Gagal',
                                  //     'Tambahkan foto terlebih dahulu!',
                                  //     backgroundColor: Colors.white);
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
        _addTamuModel.tanggalController.text =
            DateFormat("yyyy-MM-dd").format(value.toLocal()).toString();
        refreshData(_addTamuModel);
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
        _addTamuModel.waktuController.text = _time;
        refreshData(_addTamuModel);
      });
    });
  }

  @override
  void onError(String error) {
    Fluttertoast.showToast(
        msg: 'Upload gagal',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 15);
  }

  @override
  void onSuccess(String success) {}

  @override
  void refreshData(AddTamuModel addTamuModel) {
    setState(() {
      _addTamuModel = addTamuModel;
    });
  }

  @override
  void refreshDataRumah(PenghuniResponse penghuniResponse) {}

  @override
  void refreshLoading(bool isLoading) {
    _addTamuModel.isLoading = isLoading;
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
