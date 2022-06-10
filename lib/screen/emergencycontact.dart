// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../src/model/emergency_contact_model.dart';
import '../src/resources/contactApi.dart';
import 'fragment/component/clipath.dart';
import 'fragment/component/ligh_colors.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({Key? key}) : super(key: key);

  @override
  _EmergencyContactState createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontak Darurat'),
        backgroundColor: LightColors.kDarkYellow
      ),
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
          FutureBuilder<List<ContactModel>>(
            future: ContactServices.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData) {
                return ContactList(contacts: snapshot.data!);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class ContactList extends StatelessWidget {
  const ContactList({Key? key, required this.contacts}) : super(key: key);

  final List<ContactModel> contacts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          ContactModel data = contacts[index];
          return GestureDetector(
            onTap: () async {
              await canLaunch("tel:" + data.phone)
                  ? await launch("tel:" + data.phone)
                  : throw 'Could not launch tel';
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 3,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.addressBook,
                    size: 40,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(data.phone)
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
