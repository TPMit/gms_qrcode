// ignore_for_file: no_logic_in_create_state, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gms_mobile/screen/fragment/shift/shift_model.dart';

import '../../home.dart';
import '../component/ligh_colors.dart';
import '../other/back_button.dart';
import '../other/top_container.dart';

class Addshift extends StatefulWidget {
  final String idSite, pattern;

  const Addshift({Key? key, required this.idSite, required this.pattern})
      : super(key: key);
  @override
  _AddshiftState createState() => _AddshiftState(idSite, pattern);
}

class _AddshiftState extends State<Addshift> {
  late String idSite, pattern;
  _AddshiftState(this.idSite, this.pattern);
  late String? selectedCode;
  late String? selectedNik;

  late List<Securities> _listEmployee;
  late List<DetailShift> _listShift;
  bool _isLoadingShift = false;
  bool _isLoadingEmployee = false;

  @override
  void initState() {
    super.initState();
    ModelShift.getDetailShift(pattern).then((listshift) {
      setState(() {
        _isLoadingShift = true;
        _listShift = listshift;
      });
    });
    ModelSiteEmployees.getSecurities(idSite).then((listemployee) {
      setState(() {
        _isLoadingEmployee = true;
        _listEmployee = listemployee;
      });
    });
  }

  Future<http.Response> addShift(String nik, String code) {
    String apiURL = "https://hris.tpm-facility.com/attendance/addshift";

    return http.post(Uri.parse(apiURL), body: {'nik': nik, 'code': code});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LightColors.kLightYellow,
        body: Column(
          children: [
            SafeArea(
              child: TopContainer(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: const [
                      MyBackButton(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Tambahkan Shift",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Shift : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButton<String>(
                      value: selectedCode,
                      isExpanded: true,
                      isDense: false,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      underline: const SizedBox(),
                      //dropdownColor: Colors.grey,
                      hint: const Text("Pilih shift"),
                      items: (_isLoadingShift != true)
                          ? []
                          : _listShift.map((shift) {
                              return DropdownMenuItem(
                                  value: shift.shiftCode,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(shift.shiftCode +
                                        " - " +
                                        shift.timeIn +
                                        " s/d " +
                                        shift.timeOut),
                                  ));
                            }).toList(),
                      onChanged: (val) => setState(() => selectedCode = val),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Nama Security : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButton<String>(
                      value: selectedNik,
                      isExpanded: true,
                      isDense: false,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      underline: const SizedBox(),
                      //dropdownColor: Colors.grey,
                      hint: const Text("Pilih Security"),
                      items: (_isLoadingEmployee != true)
                          ? []
                          : _listEmployee.map((data) {
                              return DropdownMenuItem(
                                  value: data.nik,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(data.name),
                                  ));
                            }).toList(),
                      onChanged: (nik) => setState(() => selectedNik = nik),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          addShift(selectedNik!, selectedCode!);
                          print("add to " + selectedCode!);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const Home()),
                              (Route<dynamic> route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: LightColors.kDarkYellow),
                        child: const Text("Tambahkan")),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
