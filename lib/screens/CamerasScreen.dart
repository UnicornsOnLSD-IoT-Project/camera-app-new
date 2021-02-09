import 'package:flutter/material.dart';

import '../components/CamerasScreen/CamerasList.dart';

class CamerasScreen extends StatelessWidget {
  const CamerasScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cameras"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      ),
      body: CamerasList(),
    );
  }
}
