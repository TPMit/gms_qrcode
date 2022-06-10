// // ignore_for_file: no_logic_in_create_state

// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Absensi extends StatefulWidget {
//   final String inOut;
//   const Absensi({Key? key, required this.inOut}) : super(key: key);
//   @override
//   _AbsensiState createState() => _AbsensiState(inOut);
// }

// class _AbsensiState extends State<Absensi> {
//   late DateTime date = DateTime.now();
//   //String dateFormat = DateFormat('dd-MM-yyyy hh:mm').format(date);
//   String inOut;
//   _AbsensiState(this.inOut);
//   late SharedPreferences _prefs;
//   late String _nik, qrcode = 'unknown', _idsite;
//   late File _image;
//   late ImagePicker imagePicker = ImagePicker();

//   var locationMessage = "";

//   Future<void> getCurrentLocation() async {
//     var position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     var lat = position.latitude;
//     var long = position.longitude;
//     setState(() {
//       locationMessage = "$lat,$long";
//     });
//   }

//   Future getImageCamera() async {
//     var imageFile = await imagePicker.getImage(source: ImageSource.camera);
//     setState(() {
//       _image = File(imageFile.path);
//     });
//     upload(_image);
//     Navigator.pop(context);
//   }

//   Future upload(File imageFile) async {
//     var stream = new http.ByteStream(_image.openRead());
//     stream.cast();
//     var length = await imageFile.length();
//     var url =
//         Uri.parse("https://hris.tpm-facility.com/attendance/upload_selfie");
//     var request = new http.MultipartRequest("POST", url);

//     var multipartFile =
//         new http.MultipartFile("image", stream, length, filename: 'x.jpg');

//     request.files.add(multipartFile);
//     request.fields['nik'] = _nik;
//     request.fields['is_in'] = inOut;
//     request.fields['id_site'] = _idsite;
//     request.fields['qr_code'] = qrcode;
//     request.fields['coordinate'] = locationMessage;

//     var response = await request.send();

//     if (response.statusCode == 200) {
//       print("IMAGE UPLOADED");
//     } else {
//       print("IMAGE FAILED");
//     }
//   }

//   Future doAttendance() async {
//     try {
//       qrcode = await FlutterBarcodeScanner.scanBarcode(
//           "#3954A4", "Cancel", true, ScanMode.QR);
//       print(qrcode);
//       getCurrentLocation();
//     } on PlatformException {
//       qrcode = 'unknown';
//       locationMessage = 'Lokasi tidak tersimpan';
//     }

//     setState(() {
//       if (qrcode != '-1') {
//         showDialog(
//             context: context,
//             builder: (BuildContext context) => AlertDialog(
//                   title: Text("Ambil Swafoto"),
//                   content: Text("Pastikan anda swafoto di area absensi"),
//                   actions: <Widget>[
//                     TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text("Kembali")),
//                     TextButton(
//                         onPressed: getImageCamera, child: Text("Lanjutkan")),
//                   ],
//                 ));
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     SharedPreferences.getInstance().then((prefs) {
//       setState(() => this._prefs = prefs);
//       this._nik = this._prefs.get('nik') ?? 'No NIK';
//       this._idsite = this._prefs.get('idsite') ?? 'No ID site';
//     });
//     doAttendance();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: LightColors.kLightYellow,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 MyBackButton(),
//                 SizedBox(
//                   height: 30.0,
//                 ),
//                 Text(
//                   "Today",
//                   style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
//                 ),
//                 Text(
//                   DateFormat('EEEE, d MMMM y').format(date),
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 Container(
//                   height: 400,
//                   alignment: Alignment.center,
//                   child: _image == null
//                       ? new Text(
//                           "Anda Belum Melakukan Selfie",
//                           style: TextStyle(color: Colors.grey),
//                         )
//                       : Column(
//                           children: [
//                             Flexible(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: new Image.file(_image),
//                               ),
//                             ),
//                             Text("Absen Foto dan Lokasi berhasil direkam")
//                           ],
//                         ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }

// // Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             _image == null
// //                 ? new Text("Anda Belum Melakukan Selfie")
// //                 : new Image.file(_image),
// //             _image == null
// //                 ? new Text("Silahkan Coba Lagi")
// //                 : new Text("Anda Berhasil Melakukan Absensi")
// //           ],
// //         ),
// //       ),
