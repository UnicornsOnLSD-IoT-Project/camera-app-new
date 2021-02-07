import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/CameraServerApiHelper.dart';
import 'LoginScreen.dart';
import 'CamerasScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CameraServerApiHelper cameraServerApiHelper =
        GetIt.instance<CameraServerApiHelper>();

    if (cameraServerApiHelper.userCount == 0) return LoginScreen();

    return CamerasScreen();
  }
}
