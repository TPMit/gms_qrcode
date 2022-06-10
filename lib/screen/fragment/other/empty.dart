import 'package:flutter/material.dart';

import '../component/ligh_colors.dart';
import 'back_button.dart';

class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LightColors.kLightYellow,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: const [
                MyBackButton(),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "UNAVAILABLE",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
                Text(
                  "Coming Soon",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Center(
                  child: Text("Menu belum tersedia"),
                )
              ],
            ),
          ),
        ));
  }
}
