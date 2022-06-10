// ignore_for_file: no_logic_in_create_state, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gms_mobile/screen/fragment/shift/shift_model.dart';

import '../../home.dart';
import '../component/ligh_colors.dart';
import '../other/back_button.dart';
import '../other/top_container.dart';

class Editshift extends StatefulWidget {
  final String nik, name, shiftCode, shift, pattern;

  const Editshift(
      {Key? key,
      required this.nik,
      required this.name,
      required this.shiftCode,
      required this.shift,
      required this.pattern})
      : super(key: key);
  @override
  _EditshiftState createState() =>
      _EditshiftState(nik, name, shiftCode, shift, pattern);
}

class _EditshiftState extends State<Editshift> {
  late String nik, name, shiftCode, shift, pattern;
  _EditshiftState(
      this.nik, this.name, this.shiftCode, this.shift, this.pattern);
  late String selectedValue;

  late List<DetailShift> _listItem;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    ModelShift.getDetailShift(pattern).then((listItem) {
      setState(() {
        _isLoading = true;
        _listItem = listItem;
        selectedValue = shiftCode;
      });
    });
  }

  Future<http.Response> updateShift(String code) {
    String apiURL = "https://hris.tpm-facility.com/attendance/updateshift";

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
                    children: [
                      const MyBackButton(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(shiftCode + " - " + shift)
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
                      value: selectedValue,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      underline: const SizedBox(),
                      //dropdownColor: Colors.grey,
                      hint: Text(shiftCode + " - " + shift),
                      items: (_isLoading != true)
                          ? []
                          : _listItem.map((data) {
                              return DropdownMenuItem(
                                  value: data.shiftCode,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(data.shiftCode +
                                        " - " +
                                        data.timeIn +
                                        " s/d " +
                                        data.timeOut),
                                  ));
                            }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          print(newValue);
                          selectedValue = newValue!;
                        });
                        print(selectedValue);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          updateShift(selectedValue);
                          print("update to " + selectedValue);
                          
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Home()),
                              (Route<dynamic> route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: LightColors.kDarkYellow),
                        child: const Text("Simpan")),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
