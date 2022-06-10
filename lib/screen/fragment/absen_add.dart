// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../../src/model/absen_model.dart';
import '../../src/model/list_absensi_status.dart';
import '../../src/model/list_member_model.dart';
import '../../src/presenter/absen_presenter.dart';
import '../../src/resources/absenApi.dart';
import '../../src/state/absen_state.dart';
import 'component/clipath.dart';
import 'component/customdialogwithcontainer.dart';
import 'component/ligh_colors.dart';

import 'package:get_storage/get_storage.dart';
import '../../helper/getStorage.dart' as constants;
import 'component/roundedbutton.dart';
import 'component/roundeddropdown.dart';
import 'component/roundedinputfield.dart';
import 'package:http/http.dart' as http;

class AddAbsenScreen extends StatefulWidget {
  const AddAbsenScreen({Key? key}) : super(key: key);

  @override
  _AddAbsenScreenState createState() => _AddAbsenScreenState();
}

class _AddAbsenScreenState extends State<AddAbsenScreen>
    with SingleTickerProviderStateMixin
    implements AbsenState {
  late AbsenPresenter _absenPresenter;

  _AddAbsenScreenState() {
    _absenPresenter = AbsenPresenter();
  }

  @override
  void initState() {
    super.initState();
    _absenPresenter.view = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('pilih Anggota'),
          leading: IconButton(onPressed: (){
            Navigator.pushNamed(context, "/absen");  
          }, icon: const Icon(LineIcons.arrowLeft)
          ),
          backgroundColor: LightColors.kDarkYellow),
      body: Stack(
        children: [
          ClipPath(
            clipper: TClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 12.0,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color(0xff25509e),
                  LightColors.kDarkYellow,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
              )),
            ),
          ),
          FutureBuilder<List<ListMemberModel>>(
            future:
                ListAbsenService.getMember(GetStorage().read(constants.idSite)),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return MemberList(selectSession: snapshot.data!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }

  @override
  void onError(String error) {}

  @override
  void onSuccess(String success) {}

  @override
  void refreshData(AbsenModel absenModel) {
    setState(() {
    });
  }

  @override
  void showstatusKondisi(BuildContext context) {
    
  }
}

class MemberList extends StatefulWidget {
  const MemberList({Key? key, required this.selectSession}) : super(key: key);
  final List<ListMemberModel> selectSession;

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.selectSession.length,
        itemBuilder: (context, index) {
          ListMemberModel data = widget.selectSession[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => CustomDialogContainer(
                      title: data.name,
                      child: DropdownSelectAbsensi(nik: data.nik)));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  data.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        });
  }
}

/// This is the stateful widget that the main application instantiates.
class DropdownSelectAbsensi extends StatefulWidget {
  final String nik;
  const DropdownSelectAbsensi({Key? key, required this.nik}) : super(key: key);

  @override
  State<DropdownSelectAbsensi> createState() => _DropdownSelectAbsensiState();
}

/// This is the private State class that goes with DropdownSelectAbsensi.
class _DropdownSelectAbsensiState extends State<DropdownSelectAbsensi> {
  int selectedAbsensi = 1;
  bool showInputHour = false;
  int inputHour = 0;
  String? hour;

  Future _postAbsensi() async {
    Map<String, dynamic> content = <String, dynamic>{};
    content['nik'] = widget.nik;
    content['att_status'] = selectedAbsensi.toString();
    content['id_site'] = GetStorage().read(constants.idSite);
    content['hours'] = hour ?? '0';
    return await http.post(
      Uri.https('gmsnv.mindotek.com', 'attendance/absenbydanru'),
      body: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return FutureBuilder<List<ListAbsensiStatus>>(
      future: ListAbsenService.getAbsensiStatus(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            children: [
              RoundedDropdown(
                  value: selectedAbsensi,
                  hintText: 'Pilih..',
                  // icon: Icons.timelapse,
                  items: snapshot.data!.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item.keterangan,
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: int.parse(item.id),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      selectedAbsensi = value!;
                      if (selectedAbsensi == 15 || selectedAbsensi == 16) {
                        showInputHour = true;
                        inputHour = 1;
                      } else {
                        showInputHour = false;
                        inputHour = 0;
                      }
                    });
                    print(selectedAbsensi);
                    print(showInputHour);
                    print(inputHour);
                  }),
              Visibility(
                  visible: showInputHour,
                  child: RoundedInputField(
                    inputType: TextInputType.number,
                    icon: FontAwesomeIcons.sortNumericUp,
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
                    if (inputHour == 1) {
                      if (hour == null) {
                        Get.snackbar('Gagal', 'Kolom jam, kosong!',
                            backgroundColor: Colors.white70);
                      } else {
                        _postAbsensi();
                        Navigator.pushNamed(context, "/absen");
                      }
                    } else {
                      _postAbsensi();
                      Navigator.pushNamed(context, "/absen");
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat('dd/MM/yyyy kk:mm').format(now),
                      style: const TextStyle(color: Colors.grey),
                    )),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
