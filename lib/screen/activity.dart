import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gms_mobile/screen/fragment/loading.dart';
import 'package:gms_mobile/src/model/activity_model.dart';
import 'package:gms_mobile/src/presenter/activity_presenter.dart';
import 'package:gms_mobile/src/state/activity_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';

import '../src/resources/session.dart';
import 'fragment/activity/dialogactivitydetail.dart';
import 'fragment/activity_add.dart';

class Activities extends StatefulWidget {
  const Activities({ Key? key }) : super(key: key);

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> implements ActivityState {
  late int idUser = 0;

  late ActivityModel _activityModel;
  late ActivityPresenter _activityPresenter;

  _ActivitiesState(){
    _activityPresenter = ActivityPresenter();
  }

  @override
  void initState() {
    _activityPresenter.view = this;
    super.initState();
    Session.getId().then((value) {
      setState(() {
        idUser = int.parse(value!);
      });
    });
    _activityPresenter.getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _activityModel.isloading
        ? Loading()
        : Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Text("refresh"), 
          onPressed: () {
            setState(() {
            _activityModel.activity.clear();
            _activityPresenter.getData();
            });
           },
        ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/home");
                      },
                      child: Icon(LineIcons.arrowLeft),
                    ),
                    Text(
                      'Aktivitas',
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => const AddActivityScreen());
                        },
                        icon: const FaIcon(FontAwesomeIcons.plus))
                  ],
                )),
                SizedBox(height: 5,),
            this._activityModel.activity.length == 0
                ? Container(
                    child: Center(
                    child: Text('Belum Ada Aktivitas Yang Dikerjakan',
                        style: GoogleFonts.poppins(
                          fontStyle: FontStyle.italic,
                          textStyle:
                              TextStyle(fontSize: 14, color: Color(0xff1f1f1f)),
                        )),
                  ))
                : Expanded(
                    child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: double.infinity,
                    color: Color(0xffecedf2),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                    itemCount:
                                        this._activityModel.activity.length,
                                    scrollDirection: Axis.vertical,
                                    primary: false,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int itemIndex) =>
                                            InkWell(
                                      onTap: () {
                                       showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DialogActivityDetail(
                                                    image: _activityModel
                                                        .activity[itemIndex].images,
                                                    name: _activityModel
                                                        .activity[itemIndex]
                                                        .name + ' - ' +_activityModel
                                                        .activity[itemIndex]
                                                        .dateTime,
                                                    activity: _activityModel
                                                        .activity[itemIndex]
                                                        .activity,
                                                  ));
                                      },
                                      child: Container(
                                        height: 100,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Icon(
                                              Ionicons.calendar_outline,
                                              size: 48,
                                              color: Color(0xff485460),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  _activityModel
                                                          .activity[itemIndex]
                                                          .name + ' : ' + _activityModel
                                                          .activity[itemIndex]
                                                          .activity +
                                                      '\n' +
                                                      _activityModel
                                                          .activity[itemIndex]
                                                          .dateTime,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff1f1f1f)),
                                                  ),
                                                  maxLines: 2,
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Ionicons.chevron_forward,
                                              size: 24,
                                              color: Color(0xffe5e5e5),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  @override
  void onError(String error) {
    
  }

  @override
  void onSuccess(String success) {
    
  }

  @override
  void refreshData(ActivityModel activityModel) {
    setState(() {
      _activityModel = activityModel;
    });
  }
}

// class ActivityList extends StatelessWidget {
//   const ActivityList({Key? key, required this.activities}) : super(key: key);
//   final List<AcitivityResponse> activities;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: activities.length,
//         itemBuilder: (context, index) {
//           AcitivityResponse data = activities[index];
//           return GestureDetector(
//             onTap: () => showDialog(
//                 context: context,
//                 builder: (context) => DialogActivityDetail(
//                       image: data.images,
//                       name: data.name,
//                       activity: data.activity,
//                     )),
//             child: Container(
//               padding:const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
//               margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5), color: Colors.white),
//               child: Column(
//                 children: [
//                   Text(
//                     data.activity,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('ditambahkan pada ' +
//                       DateFormat('kk:mm').format(data.dateTime))
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
