import 'package:flutter/material.dart';

import '../models/CameraServerApiModels.dart';
import '../components/SelectedCameraScreen/ImageTimeLapse.dart';

class SelectedCameraScreen extends StatelessWidget {
  const SelectedCameraScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Camera camera = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(camera.name),
      ),
      body: ImageTimeLapse(camera: camera),
    );
  }
}
