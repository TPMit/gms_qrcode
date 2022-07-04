import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gms_mobile/helper/getStorage.dart' as constants;
import 'package:gms_mobile/screen/home.dart';
import 'package:gms_mobile/src/resources/session.dart';

import '../../../src/resources/memberservice.dart';
import '../component/background.dart';

class SelectSession extends StatefulWidget {
  const SelectSession({Key? key}) : super(key: key);

  @override
  _SelectSessionState createState() => _SelectSessionState();
}

class _SelectSessionState extends State<SelectSession> {
  String idsite = GetStorage().read(constants.idSite);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Sesi Anggota'),
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
                return Center(
                  child: Text(
                    'Tidak ada anggota.',
                    style: TextStyle(color: Colors.white38),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class MemberList extends StatelessWidget {
  const MemberList({Key? key, required this.selectSession}) : super(key: key);
  final List<ListMembersModel> selectSession;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: selectSession.length,
        itemBuilder: (context, index) {
          ListMembersModel data = selectSession[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () async {
                      await GetStorage().write(constants.idUser, data.idUser);
                      await GetStorage().write(constants.nik, data.nik);
                      await GetStorage().write(constants.idSite, data.idSite);
                      await GetStorage().write(constants.namaUser, data.username);
                      await GetStorage().write(constants.idPosition, data.idPosition);
                      print('===' + data.idUser);
                      print('===' + data.nik);
                      print('===' + data.idSite);
                      print('===' + data.username);
                      Session.setId(data.idUser);
                      Session.setName(data.username);
                      Session.setIdSite(data.idSite);
                      Session.setIdPosition(data.idPosition);
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) => Home()));
                    },
                    child: Text('Pilih'))
              ],
            ),
          );
        });
  }
}
