import 'package:flutter/material.dart';

class DialogPatrolDetail extends StatelessWidget {
  const DialogPatrolDetail(
      {Key? key,
      required this.image,
      required this.name,
      required this.activity,
      required this.jam,
      required this.status})
      : super(key: key);
  final String name;
  final String image, activity;
  final String jam;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45,left: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Detail Patroli",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Oleh: " + name),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(activity),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(jam),
                          const SizedBox(
                            height: 8,
                          ),
                          status == '0'
                          ? Text('Status: Patrol belum dilakukan', style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14),)
                          : Text(
                                  'Status: Patrol sudah dilakukan',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
