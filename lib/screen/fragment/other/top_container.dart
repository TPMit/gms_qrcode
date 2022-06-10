import 'package:flutter/material.dart';

import '../component/ligh_colors.dart';

class TopContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;

  const TopContainer({Key? key, required this.height, required this.width, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: LightColors.kDarkYellow,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}
