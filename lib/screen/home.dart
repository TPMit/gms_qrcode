import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gms_mobile/screen/absen.dart';
import 'package:gms_mobile/screen/absen_keluar.dart';
import 'package:gms_mobile/screen/activity.dart';
import 'package:gms_mobile/screen/tamu.dart';
import 'package:gms_mobile/src/model/home_model.dart';
import 'package:gms_mobile/src/presenter/home_presenter.dart';
import 'package:gms_mobile/src/state/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../src/resources/session.dart';
import 'accidentreport.dart';
import 'emergencycontact.dart';
import 'fragment/component/ligh_colors.dart';
import 'fragment/other/patrol_awal.dart';
import 'fragment/other/top_container.dart';
import 'dart:math';

// import 'fragment/shift/shift_anggota.dart';
import 'jumlahPengunjung.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements HomeState {
  // late HomeModel _homeModel;
  late HomePresenter _homePresenter;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String _name = "PT. Trimitra Putra Mandiri";
  String _idposition = "1";
  double value = 0;
  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  _HomeState() {
    _homePresenter = HomePresenter();

    Session.checkUser().then((check) {
      if (check) {
      } else {
        Navigator.pushReplacementNamed(context, "/landing");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _homePresenter.view = this;
    Session.getName().then((value) {
      setState(() {
        _name = value!;
      });
    });
    Session.getIdPosition().then((value) {
      setState(() {
        _idposition = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: LightColors.kLightYellow,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [LightColors.kLightYellow, Colors.blue],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight)),
              ),
              // NAVIGATION
              Container(
                width: 200.0,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    DrawerHeader(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   'assets/img/alogo.png',
                        //   fit: BoxFit.fill,
                        // ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          _name,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    )),
                    Expanded(
                        child: ListView(
                      children: [
                        ListTile(
                          onTap: () {},
                          leading: const Icon(Icons.home),
                          title: const Text(
                            "Home",
                            style: TextStyle(),
                          ),
                        ),
                        // ListTile(
                        //   onTap: () {},
                        //   leading: const Icon(
                        //     Icons.person,
                        //   ),
                        //   title: const Text(
                        //     "User",
                        //     style: TextStyle(),
                        //   ),
                        // ),
                        // ListTile(
                        //   onTap: () {
                        //     Navigator.of(context)
                        //         .push(MaterialPageRoute(builder: (context) {
                        //       return const Listshift();
                        //     }));
                        //   },
                        //   leading: const Icon(
                        //     Icons.settings,
                        //   ),
                        //   title: const Text(
                        //     "Shift",
                        //     style: TextStyle(),
                        //   ),
                        // ),
                        ListTile(
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.clear();
                            GetStorage().erase();
                            Navigator.pushNamed(context, "/");
                          },
                          leading: const Icon(
                            Icons.logout,
                          ),
                          title: const Text(
                            "Logout",
                            style: TextStyle(),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),

              // wrap main screen
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: value),
                duration: const Duration(microseconds: 500),
                builder: (_, double val, __) {
                  return (Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..setEntry(0, 3, 200 * val)
                      ..rotateY((pi / 6) * val),
                    child: Scaffold(
                      body: Column(
                        children: <Widget>[
                          TopContainer(
                            height: 200,
                            width: width,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              value == 0
                                                  ? value = 1
                                                  : value = 0;
                                            });
                                          },
                                          child: const Icon(Icons.menu,
                                              color: LightColors.kDarkBlue,
                                              size: 30.0),
                                        ),
                                      ),
                                      // const Padding(
                                      //   padding: EdgeInsets.all(10.0),
                                      //   child: Icon(Icons.notifications,
                                      //       color: LightColors.kDarkBlue,
                                      //       size: 25.0),
                                      // ),
                                      Visibility(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context, '/selectSession');
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.userAlt,
                                                  color: Colors.teal,
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  'absen user\n lain',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black45),
                                                )
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        const Flexible(
                                          child: CircleAvatar(
                                            backgroundColor:
                                                LightColors.kDarkBlue,
                                            radius: 35.0,
                                            backgroundImage: AssetImage(
                                              'assets/img/avatar.png',
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                _name,
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                  fontSize: 22.0,
                                                  color: LightColors.kDarkBlue,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Text(
                                                (_idposition == '2')
                                                    ? "Komandan Regu"
                                                    : "Security",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              //         Container(
                                              //           child: ListTile(
                                              //             onTap: () {
                                              //               setState(() async {
                                              //                 SharedPreferences preferences =
                                              // await SharedPreferences.getInstance();
                                              //                 preferences.clear();
                                              //                 GetStorage().erase();
                                              //                 Navigator.pushReplacement(
                                              //                     context,
                                              //                     MaterialPageRoute(
                                              //                         builder: (context) =>
                                              //                             const Login()));
                                              //               });
                                              //             },
                                              //             leading: const Icon(
                                              //               Icons.logout,
                                              //             ),
                                              //             title: const Text(
                                              //               "Logout",
                                              //               style: TextStyle(),
                                              //             ),
                                              //           ),
                                              //         ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        subheading('Quick Menus'),
                                        Row(
                                          children: const <Widget>[
                                            Menu(
                                              cardColor: LightColors.kGreen,
                                              cardIcon:
                                                  Icons.people_alt_outlined,
                                              title: 'Data tamu',
                                              subtitle: 'Input Data tamu',
                                              screenWidget: TamuScreen(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Menu(
                                              cardColor:
                                                  LightColors.kDarkYellow,
                                              cardIcon:
                                                  Icons.notification_important,
                                              title: 'SOS',
                                              subtitle: 'Emergency Contact',
                                              screenWidget: EmergencyContact(),
                                            ),
                                            SizedBox(width: 20.0),
                                            Menu(
                                              cardColor: LightColors.kBlue,
                                              cardIcon: Icons.map_outlined,
                                              title: 'Patroli',
                                              subtitle:
                                                  'Buat laporan patroli mandiri',
                                              screenWidget: PatrolAwalScreen(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Menu(
                                              cardColor: LightColors.kDarkBlue,
                                              cardIcon: Icons.arrow_forward_rounded,
                                              title: 'Absensi Masuk',
                                              subtitle: 'Periksa absensi',
                                              screenWidget: AbsenScreen(),
                                            ),
                                            SizedBox(width: 20.0),
                                            Menu(
                                              cardColor: LightColors.kGreen,
                                              cardIcon: Icons.arrow_back_sharp,
                                              title: 'Absensi Keluar',
                                              subtitle: 'Periksa Absensi',
                                              screenWidget:
                                                  AbsenOutScreen(),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 8),
                                          child: Text(
                                            "Menu Dandru",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Menu(
                                              cardColor: LightColors.kDarkBlue,
                                              cardIcon: Icons.local_activity,
                                              title: 'Aktivitas',
                                              subtitle: 'Periksa Aktivitas',
                                              screenWidget: Activities(),
                                            ),
                                            SizedBox(width: 20.0),
                                            Menu(
                                              cardColor: LightColors.kGreen,
                                              cardIcon: Icons.location_history,
                                              title: 'Jumlah Pengunjung',
                                              subtitle: '',
                                              screenWidget: JumlahPengunjungScreen(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Menu(
                                              cardColor: LightColors.kRed,
                                              cardIcon:
                                                  Icons.warning_amber_outlined,
                                              title: 'Laporan Insiden',
                                              subtitle: 'Input Laporan Insiden',
                                              screenWidget: AccidentReport(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      //),
                    ),
                  ));
                },
              )
            ],
          ),
        ));
  }

  @override
  void onError(String error) {}

  @override
  void onSuccess(String success) {}

  @override
  void refreshData(HomeModel homeModel) {}
}

class Menu extends StatelessWidget {
  final Color cardColor;
  final IconData cardIcon;
  final String title;
  final String subtitle;
  final Widget screenWidget;

  const Menu(
      {Key? key,
      required this.cardColor,
      required this.cardIcon,
      required this.title,
      required this.subtitle,
      required this.screenWidget})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          Route route = MaterialPageRoute(builder: (context) {
            return screenWidget;
          });

          Navigator.of(context).push(route);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(15.0),
          height: 200,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  cardIcon,
                  size: 85,
                  color: Colors.white70,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
