// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../helper/getStorage.dart' as constants;
import '../../src/resources/session.dart';


class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({Key? key}) : super(key: key);

  @override
  AddActivityScreenState createState() => AddActivityScreenState();
}


class AddActivityScreenState extends State<AddActivityScreen> {
  late int idUser = 0;
  File? _image;
  ImagePicker imagePicker = ImagePicker();
  String nik = GetStorage().read(constants.nik);
  late String activity;
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Session.getId().then((value) {
      setState(() {
        idUser = int.parse(value!);
      });
      print('===');
    });
    print(Session.getId());
  }

  // Future _postMessage() async {
  //   Map<String, dynamic> content = <String, dynamic>{};
  //   content['nik'] = nik;
  //   content['activity'] = activity;
  //   print(content);
  //   return await http.post(
  //     Uri.https('hris.tpm-facility.com', 'attendance/addactivities'),
  //     body: content,
  //   );
  // }
  Future postUpload() async {
    var stream = http.ByteStream(_image!.openRead());
    stream.cast();
    var length = await _image!.length();
    var url =
        Uri.parse('https://gmsnv.mindotek.com/attendance/addactivities');
    var request = http.MultipartRequest("POST", url);
    var multipartFile =
        http.MultipartFile("image", stream, length, filename: 'x.jpg');

    request.files.add(multipartFile);
    request.fields['id_user'] = idUser.toString();
    request.fields['activity'] = activity;

    var response = await request.send();
    print(response.stream);
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      print("IMAGE UPLOADED");
      Fluttertoast.showToast(
          msg: 'Berhasil upload',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green[600],
          textColor: Colors.white,
          fontSize: 15);
      Navigator.pop(context);
    } else {
      setState(() {
        _isLoading = false;
      });
      print("IMAGE FAILED");
      Fluttertoast.showToast(
          msg: 'FAILED',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15);
    }
  }

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
          padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
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
                "Tambah Aktifitas",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                    onChanged: (value) {
                      activity = value;
                    },
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration.collapsed(
                      hintText: "",
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              _image == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Tambahkan Foto',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        height: MediaQuery.of(context).size.height * 0.3,
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
              _image == null
                  ? const SizedBox()
                  : _isLoading 
                  ? Center(child: CircularProgressIndicator(),)
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          print(idUser);
                          print(activity);
                          setState(() {
                            _isLoading = true;
                          });
                          postUpload();
                        },
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
