import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/CameraServerApiModels.dart';
import '../../services/CameraServerApiHelper.dart';
import '../errorSnackBar.dart';

class ImageTimeLapse extends StatefulWidget {
  ImageTimeLapse({Key key, @required this.camera}) : super(key: key);

  final Camera camera;

  @override
  _ImageTimeLapseState createState() => _ImageTimeLapseState();
}

class _ImageTimeLapseState extends State<ImageTimeLapse> {
  CameraServerApiHelper cameraServerApiHelper =
      GetIt.instance<CameraServerApiHelper>();

  Timer timer;
  Future imageListFuture;
  int imageCounter = 0;

  void initState() {
    super.initState();
    imageListFuture = cameraServerApiHelper.listImages(widget.camera.cameraId);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        imageCounter++;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: imageListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (imageCounter >= snapshot.data.length) imageCounter = 0;
          return Image.network(
            "${cameraServerApiHelper.currentUser.baseUrl}/Cameras/${widget.camera.cameraId}/Image?image_name=${snapshot.data[imageCounter]}",
            headers: {
              "user_token": cameraServerApiHelper.currentUser.userToken
            },
          );
        } else if (snapshot.hasError) {
          errorSnackBar(snapshot.error, context);
          return Text("Error!");
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
