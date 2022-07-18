import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../src/resources/memberservice.dart';
import '../component/background.dart';
import '../component/customdialogwithcontainer.dart';
import '../component/dropdown_absensi.dart';
import '/../helper/getStorage.dart' as constants;

class SelectAbsensi extends StatefulWidget {
  const SelectAbsensi({Key? key}) : super(key: key);

  @override
  _SelectAbsensiState createState() => _SelectAbsensiState();
}

class _SelectAbsensiState extends State<SelectAbsensi> {
  String idsite = GetStorage().read(constants.idSite);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Anggota'),
      ),
      body: Stack(
        children: [
          CustomBackground(),
          FutureBuilder<List<ListMembersModel>>(
            future: MemberService.get(idsite),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData && snapshot.data!.length > 0) {
                return MemberList(selectSession: snapshot.data!);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }
}

class MemberList extends StatefulWidget {
  const MemberList({Key? key, required this.selectSession}) : super(key: key);
  final List<ListMembersModel> selectSession;

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.selectSession.length,
        itemBuilder: (context, index) {
          ListMembersModel data = widget.selectSession[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => CustomDialogContainer(
                      title: data.username,
                      child: DropdownSelectAbsensi(idUser: data.idUser, hasilQr: 'diabsenkan', latitudeLongitude: 'diabsenkan',)));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  data.username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        });
  }
}

/// This is the stateful widget that the main application instantiates.
// class DropdownSelectAbsensi extends StatefulWidget {
//   final String nik;
//   const DropdownSelectAbsensi({Key? key, required this.nik}) : super(key: key);

//   @override
//   State<DropdownSelectAbsensi> createState() => _DropdownSelectAbsensiState();
// }

// /// This is the private State class that goes with DropdownSelectAbsensi.
// class _DropdownSelectAbsensiState extends State<DropdownSelectAbsensi> {
//   int selectedAbsensi = 1;
//   bool showInputHour = false;
//   String? hour;

//   Future _postAbsensi() async {
//     Map<String, dynamic> content = <String, dynamic>{};
//     content['nik'] = widget.nik;
//     content['att_status'] = selectedAbsensi.toString();
//     content['id_site'] = GetStorage().read('idsite');
//     content['hours'] = hour ?? '0';
//     print(content);
//     return await http.post(
//       Uri.https('gmsnv.mindotek.com', 'attendance/absenbydanru'),
//       body: content,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//     return FutureBuilder<List<ListAbsensiStatus>>(
//       future: ListAbsensiStatusService.get(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Center(
//             child: Text('An error has occurred!'),
//           );
//         } else if (snapshot.hasData && snapshot.data!.length > 0) {
//           return Column(
//             children: [
//               RoundedDropdown(
//                   value: selectedAbsensi,
//                   hintText: 'Pilih..',
//                   // icon: Icons.timelapse,
//                   items: snapshot.data!.map((item) {
//                     return DropdownMenuItem(
//                       child: Text(
//                         item.keterangan,
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       value: int.parse(item.id),
//                     );
//                   }).toList(),
//                   onChanged: (int? value) {
//                     setState(() {
//                       selectedAbsensi = value!;
//                       if (selectedAbsensi == 15 || selectedAbsensi == 16) {
//                         showInputHour = true;
//                       } else {
//                         showInputHour = false;
//                       }
//                     });
//                     print(selectedAbsensi);
//                     print(showInputHour);
//                   }),
//               Visibility(
//                   visible: showInputHour,
//                   child: RoundedInputField(
//                     inputType: TextInputType.number,
//                     icon: FontAwesomeIcons.sortNumericUp,
//                     hintText: 'banyak jam',
//                     onChanged: (String hours) {
//                       setState(() {
//                         hour = hours;
//                       });
//                     },
//                   )),
//               RoundedButton(
//                   text: 'Serahkan',
//                   color: Colors.teal,
//                   press: () {
//                     if (showInputHour) {
//                       if (hour == null) {
//                         Get.snackbar('Gagal', 'Kolom jam, kosong!',
//                             backgroundColor: Colors.white70);
//                       } else {
//                         _postAbsensi();
//                         Get.back();
//                         Get.snackbar('Berhasil', 'Absensi terunggah',
//                             backgroundColor: Colors.white70);
//                       }
//                     } else {
//                       _postAbsensi();
//                       Get.back();
//                       Get.snackbar('Berhasil', 'Absensi terunggah',
//                           backgroundColor: Colors.white70);
//                     }
//                   }),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       DateFormat('dd/MM/yyyy kk:mm').format(now),
//                       style: TextStyle(color: Colors.grey),
//                     )),
//               ),
//             ],
//           );
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
