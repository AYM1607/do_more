import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/App.dart';

main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(App());
}
