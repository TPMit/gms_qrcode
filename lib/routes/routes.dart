import 'package:flutter/material.dart';

import '../screen/activity.dart';
import '../screen/fragment/checkpoint_page.dart';
import '../screen/home.dart';
import '../screen/login.dart';
import '../screen/absen.dart';
import '../screen/tamu.dart';

final routes = {
  '/': (BuildContext context) => const Login(),
  '/home': (BuildContext context) => const Home(),
  '/absen': (BuildContext context) => const AbsenScreen(),
  '/activity': (BuildContext context) => const Activities(),
  '/accident': (BuildContext context) => const Activities(),
  '/tamu': (BuildContext context) => const TamuScreen(),
  '/checkpoint': (BuildContext context) => const CheckPointPage(),
};
