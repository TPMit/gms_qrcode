// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:gms_mobile/screen/fragment/shift/shift_add.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/ligh_colors.dart';
import '../other/back_button.dart';
import 'shift_edit.dart';
import 'shift_model.dart';

class Listshift extends StatefulWidget {
  const Listshift({Key? key}) : super(key: key);

  @override
  _ListshiftState createState() => _ListshiftState();
}

class _ListshiftState extends State<Listshift> {
  late List<Shifts> _listShift;
  late SharedPreferences _prefs;
  late String _idposition, _idsite, _pattern;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);
      _idsite = _prefs.getString('idsite') ?? "0";
      _idposition = _prefs.getString("idposition") ?? "0";
      Services.getShifts(_idsite).then((shifts) {
        setState(() {
          _listShift = shifts;
          _pattern = _listShift[0].shiftPattern;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LightColors.kLightYellow,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    MyBackButton(),
                    Text(
                      "Daftar Shifts",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                null == _listShift
                    ? const Center(
                        child: Text(
                            "Belum ada daftar shift, Lakukan penambahan shift untuk anggota!"),
                      )
                    : Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                _listShift.isEmpty ? 0 : _listShift.length,
                            itemBuilder: (BuildContext context, int index) {
                              Shifts shifts = _listShift[index];
                              return Card(
                                //DENGAN MARGIN YANG DISESUAIKAN
                                margin: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                //DENGAN KETEBALAN AGAR MEMBENTUK SHADOW SENILAI 8
                                elevation: 8,
                                //CHILD DARI CARD MENGGUNAKAN LISTTILE AGAR LEBIH MUDAH MENGATUR AREANYA
                                //KARENA SECARA DEFAULT LISTTILE TELAH TERBAGI MENJADI 3 BAGIAN
                                //POSISI KIRI (LEADING), TENGAH (TITLE), BAWAH TENGAH (SUBTITLE) DAN KANAN(TRAILING)
                                //SEHINGGA KITA HANYA TINGGAL MEMASUKKAN TEKS YANG SESUAI
                                child: ListTile(
                                  leading: Text(
                                    shifts.codeShift,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.lightGreen),
                                  ),
                                  title: Text(
                                    shifts.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 12,
                                      ),
                                      Text(" " +
                                          shifts.timeIn +
                                          " - " +
                                          shifts.timeOut),
                                    ],
                                  ),
                                  trailing: (_idposition != "2")
                                      ? const SizedBox()
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Editshift(
                                                nik: shifts.nik,
                                                name: shifts.name,
                                                shiftCode: shifts.codeShift,
                                                shift: shifts.timeIn +
                                                    " s/d " +
                                                    shifts.timeOut,
                                                pattern: shifts.shiftPattern,
                                              );
                                            }));
                                          },
                                          child: const Text(
                                            "Edit",
                                            style: TextStyle(
                                                color: Colors.lightGreen),
                                          ),
                                        ),
                                ),
                              );
                            }),
                      ),
                const SizedBox(
                  height: 28.0,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: (_idposition != "2")
            ? const SizedBox()
            : FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Addshift(idSite: _idsite, pattern: _pattern);
                  }));
                },
                label: const Text('Tambahkan Data'),
                icon: const Icon(Icons.add),
                backgroundColor: LightColors.kDarkYellow,
              ));
  }
}
