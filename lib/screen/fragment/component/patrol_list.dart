import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../src/model/list_checkpoint_model.dart';

class CheckPointList extends StatelessWidget {
  const CheckPointList({Key? key, required this.checkpoints}) : super(key: key);
  final List<ListCheckPointModel> checkpoints;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: checkpoints.length,
        itemBuilder: (context, index) {
          ListCheckPointModel data = checkpoints[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.circle,
                  color: (data.status == "1") ? Colors.blue : Colors.red,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.tanggal,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(" pada " +
                        DateFormat('kk:mm').format(data.currentdatetime)),
                  ],
                )
              ],
            ),
          );
        });
  }
}
