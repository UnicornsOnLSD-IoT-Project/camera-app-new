import 'package:flutter/material.dart';

import '../components/NewCameraScreen/NewCameraScreenBody.dart';

class NewCameraScreen extends StatelessWidget {
  const NewCameraScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Camera"),
      ),
      body: NewCameraScreenBody(),
    );
  }
}
